import 'package:flutter/material.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/dto/product/product_dto.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/repository/product/product_repository.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/useCase/product/get_products_by_category.dart';
import 'package:proyecto_alejandro_rihani/widgets/product.dart';
import 'package:proyecto_alejandro_rihani/routes/routes.dart';

class ProductsByCategoryPage extends StatefulWidget {
  final String categorySlug;
  final String categoryName;

  const ProductsByCategoryPage({
    super.key,
    required this.categorySlug,
    required this.categoryName,
  });

  @override
  _ProductsByCategoryPageState createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage> {
  late final GetProductsByCategoryUseCase _getProductsByCategoryUseCase;
  List<Product> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getProductsByCategoryUseCase = GetProductsByCategoryUseCase(ProductRepository());
    loadProducts();
  }

  Future<void> loadProducts() async {
    try {
      List<Product> fetchedProducts = await _getProductsByCategoryUseCase.execute(widget.categorySlug);
      setState(() {
        products = fetchedProducts;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar productos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart), 
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.cart);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductCard(product: product);
              },
            ),
    );
  }
}
