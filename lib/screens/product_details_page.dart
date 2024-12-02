import 'dart:convert';
import 'package:http/http.dart' as http;
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
  List<dynamic> reviews = [];

  @override
  void initState() {
    super.initState();
    addProductToSeen(widget.product);
    loadProductReviews(widget.product.id);
  }

  Future<void> loadProductReviews(int productId) async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/$productId'));

    if (response.statusCode == 200) {
      final productData = jsonDecode(response.body);
      setState(() {
        reviews = productData['reviews'] ?? []; // Asignar reviews si están presentes
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar las reviews')),
      );
    }
  }

  Future<void> addProductToSeen(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final String? seenProductsData = prefs.getString('seenProducts');
    List<Map<String, dynamic>> seenProducts = [];

    if (seenProductsData != null) {
      seenProducts = List<Map<String, dynamic>>.from(jsonDecode(seenProductsData));
    }

    final existingProductIndex = seenProducts.indexWhere((item) => item['id'] == product.id);
    if (existingProductIndex >= 0) {
      seenProducts[existingProductIndex]['viewCount'] += 1;
    } else {
      seenProducts.add({
        'id': product.id,
        'title': product.name,
        'thumbnail': product.image,
        'viewCount': 1,
      });
    }
    await prefs.setString('seenProducts', jsonEncode(seenProducts));
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
            const SizedBox(height: 24),
            if (reviews.isNotEmpty) ...[
              const Text(
                'Reseñas del Producto:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), 
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['user'] ?? 'Usuario anónimo',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            review['comment'] ?? 'Sin comentarios',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ] else ...[
              const SizedBox(height: 24),
              const Text(
                'No hay reseñas disponibles para este producto.',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ],
        ),
      ),
    );
  }

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
      if (cart.length >= 7) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No puedes agregar más de 7 productos diferentes al carrito.')),
        );
      } else if (quantityToAdd > product.stock) {
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
          'image': product.image,
        });
        await prefs.setString('cart', jsonEncode(cart));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${product.name} agregado al carrito.')),
        );
      }
    }
  }
}
