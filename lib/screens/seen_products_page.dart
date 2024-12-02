import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_alejandro_rihani/screens/product_details_page.dart';

import '../modules/categories/domain/dto/product/product_dto.dart';

class SeenProductsPage extends StatefulWidget {
  const SeenProductsPage({super.key});

  @override
  _SeenProductsPageState createState() => _SeenProductsPageState();
}

class _SeenProductsPageState extends State<SeenProductsPage> {
  List<Map<String, dynamic>> seenProducts = [];

  @override
  void initState() {
    super.initState();
    loadSeenProducts();
  }

  Future<void> loadSeenProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? seenProductsData = prefs.getString('seenProducts');

    if (seenProductsData != null) {
      setState(() {
        seenProducts = List<Map<String, dynamic>>.from(jsonDecode(seenProductsData));
      });
    }
  }

  Future<void> navigateToProductDetail(int productId) async {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products/$productId'));

      if (response.statusCode == 200) {
        final productData = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: Product(
                id: productData['id'],
                name: productData['title'],
                image: productData['thumbnail'],
                description: productData['description'],
                price: productData['price'].toDouble(),
                stock: productData['stock'],
              ),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los detalles del producto')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los detalles del producto: $e')),
      );
    }
  }

  Future<void> addToCart(int productId, String productName, double productPrice, String productImage) async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cart');
    List<Map<String, dynamic>> cart = [];

    if (cartData != null) {
      cart = List<Map<String, dynamic>>.from(jsonDecode(cartData));
    }

    final existingProductIndex = cart.indexWhere((item) => item['id'] == productId);

    if (existingProductIndex >= 0) {
      int currentQuantity = cart[existingProductIndex]['quantity'];
      cart[existingProductIndex]['quantity'] = currentQuantity + 1;
      cart[existingProductIndex]['total'] = (currentQuantity + 1) * productPrice;
    } else {
      cart.add({
        'id': productId,
        'name': productName,
        'price': productPrice,
        'quantity': 1,
        'total': productPrice,
        'date': DateTime.now().toString(),
        'image': productImage,
      });
    }

    await prefs.setString('cart', jsonEncode(cart));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$productName agregado al carrito.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Productos Vistos"),
        backgroundColor: Colors.blue,
      ),
      body: seenProducts.isEmpty
          ? const Center(child: Text("No has visto ningún producto aún."))
          : ListView.builder(
              itemCount: seenProducts.length,
              itemBuilder: (context, index) {
                final productData = seenProducts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.network(
                              productData['thumbnail'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productData['title'],
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Precio: \$${productData.containsKey('price') ? productData['price'].toStringAsFixed(2) : '0.00'}",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_shopping_cart, color: Colors.blue),
                              onPressed: () {
                                addToCart(
                                  productData['id'],
                                  productData['title'],
                                  productData.containsKey('price') ? productData['price'].toDouble() : 0.0,
                                  productData['thumbnail'],
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Visto ${productData['viewCount']} veces",
                          style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            navigateToProductDetail(productData['id']);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: const Text('Ver Detalles'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
