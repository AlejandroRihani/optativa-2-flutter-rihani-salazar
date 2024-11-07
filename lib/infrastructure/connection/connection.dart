import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_alejandro_rihani/infrastructure/connection/i_connection.dart';

class Connection implements Iconnection {
  final String baseUrl = 'https://dummyjson.com';

  @override
  Future<T> get<T>(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      print('Respuesta de API recibida: ${response.body}');
      return jsonDecode(response.body) as T;
    } else {
      print('Error en la solicitud GET: ${response.statusCode}');
      throw Exception('Error en la solicitud GET: ${response.statusCode}');
    }
  }

  @override
  Future<T> post<T, D>(String endpoint, D data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as T;
    } else {
      throw Exception('Error en la solicitud POST: ${response.statusCode}');
    }
  }

  @override
  Future<T> delete<T>(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as T;
    } else {
      throw Exception('Error en la solicitud DELETE: ${response.statusCode}');
    }
  }

  @override
  Future<T> put<T, D>(String endpoint, D data,
      {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as T;
    } else {
      throw Exception('Error en la solicitud PUT: ${response.statusCode}');
    }
  }
}
