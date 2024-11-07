import 'dart:convert';
import 'package:proyecto_alejandro_rihani/infrastructure/connection/connection.dart';
import 'package:proyecto_alejandro_rihani/modules/login/domain/dto/product/product_dto.dart';

class ProductRepository {
  final Connection _connection = Connection();

  Future<List<Product>> fetchProductsByCategory(String categorySlug) async {
    final response = await _connection.get('products/category/$categorySlug');
    
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['products'];
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener productos de la categoría: ${response.statusCode}');
    }
  }
}
