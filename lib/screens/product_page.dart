import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/dto/product/product_dto.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;

  Future<void> addToCart(Product product, int quantityToAdd) async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cart');
    List<Map<String, dynamic>> cart = [];

    if (cartData != null) {
      cart = List<Map<String, dynamic>>.from(jsonDecode(cartData));
    }

    final existingProductIndex = cart.indexWhere((item) => item['id'] == product.id);
    if (existingProductIndex >= 0) {
      int currentQuantity = cart[existingProductIndex]['quantity'];
      int newQuantity = currentQuantity + quantityToAdd;

      if (newQuantity > product.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No puedes agregar más de ${product.stock} unidades.')),
        );
      } else {
        cart[existingProductIndex]['quantity'] = newQuantity;
        cart[existingProductIndex]['total'] = newQuantity * product.price;
        await prefs.setString('cart', jsonEncode(cart));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} actualizado en el carrito con cantidad $newQuantity')),
        );
      }
    } else {
      if (quantityToAdd > product.stock) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No puedes agregar más de ${product.stock} unidades.')),
        );
      } else {
        cart.add({
          'id': product.id,
          'name': product.name,
          'price': product.price,
          'quantity': quantityToAdd,
          'total': product.price * quantityToAdd,
          'date': DateTime.now().toString(),
          'image': product.image, // Agregar la imagen del producto
        });
        await prefs.setString('cart', jsonEncode(cart));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} agregado al carrito.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de producto"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              widget.product.image,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.product.description,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Precio: \$${widget.product.price.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  "Stock: ${widget.product.stock}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      if (quantity > 1) {
                        quantity--;
                      }
                    });
                  },
                ),
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    controller: TextEditingController(text: quantity.toString()),
                    onChanged: (value) {
                      setState(() {
                        int? newValue = int.tryParse(value);
                        if (newValue != null && newValue > 0) {
                          quantity = newValue;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      if (quantity < widget.product.stock) {
                        quantity++;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('No puedes agregar más de ${widget.product.stock} unidades.')),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (quantity > 0 && quantity <= widget.product.stock) {
                  addToCart(widget.product, quantity);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cantidad no válida o mayor al stock disponible')),
                  );
                }
              },
              icon: const Icon(Icons.add),
              label: const Text("Agregar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
