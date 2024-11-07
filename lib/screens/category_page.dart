import 'package:flutter/material.dart';
import 'package:proyecto_alejandro_rihani/modules/login/domain/dto/category/category_dto.dart';
import 'package:proyecto_alejandro_rihani/modules/login/domain/repository/category/category_repository.dart';
import 'package:proyecto_alejandro_rihani/modules/login/useCase/category/get_categories.dart';
import 'package:proyecto_alejandro_rihani/screens/products_by_cat_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late final GetCategoriesUseCase _getCategoriesUseCase;
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCategoriesUseCase = GetCategoriesUseCase(CategoryRepository());
    loadCategories();
  }

  Future<void> loadCategories() async {
  try {
    print('Iniciando carga de categorías...');
    List<Category> fetchedCategories = await _getCategoriesUseCase.execute(null);
    setState(() {
      categories = fetchedCategories;
      isLoading = false;
    });
    print('Categorías cargadas: $categories');
  } catch (e) {
    setState(() {
      isLoading = false;
    });
    print('Error al cargar categorías: $e');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  leading: const Icon(Icons.category, color: Colors.blue),
                  title: Text(category.name),
                  subtitle: Text(category.url),
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
