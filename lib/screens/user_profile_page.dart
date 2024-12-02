import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userProfileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('userId');

      if (userId == null) {
        throw Exception("No se pudo obtener el ID del usuario");
      }

      final response = await http.get(Uri.parse('https://dummyjson.com/users/$userId'));

      if (response.statusCode == 200) {
        setState(() {
          userProfileData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los datos del perfil')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil de Usuario"),
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userProfileData != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(userProfileData!['image']),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "${userProfileData!['firstName']} ${userProfileData!['lastName']}",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("Edad: ${userProfileData!['age']} años"),
                      const SizedBox(height: 10),
                      Text("Correo Electrónico: ${userProfileData!['email']}"),
                      const SizedBox(height: 10),
                      Text("Teléfono: ${userProfileData!['phone']}"),
                      const SizedBox(height: 10),
                      Text("Nombre de Usuario: ${userProfileData!['username']}"),
                      const SizedBox(height: 10),
                      Text("Fecha de Nacimiento: ${userProfileData!['birthDate']}"),
                      const SizedBox(height: 10),
                      Text("Tipo de Sangre: ${userProfileData!['bloodGroup']}"),
                      const SizedBox(height: 10),
                      Text("Altura: ${userProfileData!['height']} cm"),
                      const SizedBox(height: 10),
                      Text("Peso: ${userProfileData!['weight']} kg"),
                      const SizedBox(height: 10),
                      Text("Color de Ojos: ${userProfileData!['eyeColor']}"),
                      const SizedBox(height: 10),
                      Text("Color de Cabello: ${userProfileData!['hair']['color']}"),
                      const SizedBox(height: 10),
                      Text("Tipo de Cabello: ${userProfileData!['hair']['type']}"),
                    ],
                  ),
                )
              : const Center(child: Text("No se pudieron cargar los datos del perfil")),
    );
  }
}
