import 'dart:convert';
import 'package:proyecto_alejandro_rihani/infrastructure/connection/connection.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/dto/category/category_dto.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/dto/product/product_dto.dart';
import 'package:proyecto_alejandro_rihani/modules/categories/domain/repository/repository.dart';

class CategoryRepository implements Repository<void, List<Category>> {
  final Connection _connection = Connection();

  @override
  Future<List<Category>> execute(void params) async {
    final response = await _connection.get('products/categories');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Category> categories = data.map((item) => Category.fromJson(item)).toList();

      for (Category category in categories) {
        final productResponse = await _connection.get('products/category/${category.slug}');
        if (productResponse.statusCode == 200) {
          List<dynamic> products = jsonDecode(productResponse.body)['products'];
          if (products.isNotEmpty) {
            final firstProduct = Product.fromJson(products[0]);
            category.firstProductImage = firstProduct.image;
          }
        }
      }

      return categories;
    } else {
      throw Exception('Error al obtener las categorías: ${response.statusCode}');
    }
  }
}
