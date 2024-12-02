import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos Vistos'),
        backgroundColor: Colors.blue,
      ),
      body: seenProducts.isEmpty
          ? const Center(child: Text("No has visto ningún producto aún."))
          : ListView.builder(
              itemCount: seenProducts.length,
              itemBuilder: (context, index) {
                final product = seenProducts[index];
                return ListTile(
                  leading: Image.network(
                    product['thumbnail'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product['title']),
                  subtitle: Text("Visto ${product['viewCount']} veces"),
                );
              },
            ),
    );
  }
}
