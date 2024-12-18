import 'package:flutter/material.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/dto/category/category_dto.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/repository/category/category_repository.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/useCase/category/get_categories.dart';
import 'package:proyecto_alejandro_rihani/screens/products_by_cat_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final GetCategoriesUseCase _getCategoriesUseCase;
  static List<Category>? _cachedCategories; 
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCategoriesUseCase = GetCategoriesUseCase(CategoryRepository());
    if (_cachedCategories == null) {
      loadCategories();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadCategories() async {
    try {
      List<Category> fetchedCategories = await _getCategoriesUseCase.execute(null);
      setState(() {
        _cachedCategories = fetchedCategories; 
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      print('Error al cargar categorías: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _cachedCategories!.length,
              itemBuilder: (context, index) {
                final category = _cachedCategories![index];
                return ListTile(
                  leading: category.firstProductImage != null
                      ? Image.network(
                          category.firstProductImage!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.category, color: Colors.blue),
                  title: Text(category.name),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsByCategoryPage(
                          categorySlug: category.slug,
                          categoryName: category.name,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
