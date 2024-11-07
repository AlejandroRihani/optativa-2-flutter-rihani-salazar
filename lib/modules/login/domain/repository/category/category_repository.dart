import 'dart:convert';
import 'package:proyecto_alejandro_rihani/infrastructure/connection/connection.dart';
import 'package:proyecto_alejandro_rihani/modules/login/domain/dto/category/category_dto.dart';
import 'package:proyecto_alejandro_rihani/modules/login/domain/repository/repository.dart';


class CategoryRepository implements Repository<void, List<Category>> {
  final Connection _connection = Connection();

  @override
  Future<List<Category>> execute(void params) async {
    final response = await _connection.get('products/categories');
    print('Response: $response');
    if (response.statusCode == 200 && response is String) {
      List<dynamic> data = jsonDecode(response);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Error al obtener las categorías: ${response.statusCode}');
    }
  }
}
