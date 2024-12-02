import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/modules/categories/domain/dto/product/product_dto.dart';
import '/screens/product_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  Future<void> _searchProducts(String query) async {
    final response = await http.get(Uri.parse('https://dummyjson.com/products/search?q=$query'));

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = jsonDecode(response.body)['products'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al buscar productos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Productos'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar productos',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _searchProducts,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final productData = _searchResults[index];

                final product = Product(
                  id: productData['id'],
                  name: productData['title'],
                  image: productData['thumbnail'],
                  description: productData['description'],
                  price: productData['price'].toDouble(),
                  stock: productData['stock'],
                );

                return ListTile(
                  leading: Image.network(
                    product.image,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text("\$${product.price}"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
