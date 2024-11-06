import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_alejandro_rihani/infrastructure/connection/i_connection.dart';

class Connection implements Iconnection {
  @override
  Future<T> get<T>(String url, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(url), headers: headers);
    return jsonDecode(response.body) as T;
  }

  @override
  Future<T> post<T, D>(String url, D data,
      {Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as T;
    }
    throw Exception('Error en la solicitud: ${response.statusCode}');
  }

  @override
  delete<T>(String url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  put<T, D>(String url, D data, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }
}
