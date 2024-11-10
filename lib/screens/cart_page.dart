import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cart = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cart');

    if (cartData != null) {
      setState(() {
        cart = List<Map<String, dynamic>>.from(jsonDecode(cartData));
        totalAmount = cart.fold(
          0.0,
          (sum, item) => sum + (item['price'] * item['quantity']),
        );
      });
    }
  }

  void removeFromCart(int index) async {
    setState(() {
      cart.removeAt(index);
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(cart));
    loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrito de Compra"),
        backgroundColor: Colors.blue,
      ),
      body: cart.isEmpty
          ? const Center(child: Text("Tu carrito está vacío"))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final item = cart[index];
                return ListTile(
                  leading: const Icon(Icons.shopping_cart, color: Colors.blue),
                  title: Text(item['name']),
                  subtitle: Text(
                      "Cantidad: ${item['quantity']} - Total: \$${item['total'].toStringAsFixed(2)}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      removeFromCart(index);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Total a pagar: \$${totalAmount.toStringAsFixed(2)}",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
