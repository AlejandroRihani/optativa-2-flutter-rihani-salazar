import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_alejandro_rihani/main.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; 
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://ps.w.org/login-customizer/assets/icon-256x256.png?rev=2455454',
              height: 200,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: "Usuario",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true; 
                      });

                      final username = _usernameController.text;
                      final password = _passwordController.text;

                      if (username.isEmpty || password.isEmpty) {
                        setState(() {
                          _isLoading = false; 
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor, ingrese usuario y contraseña')),
                        );
                        return;
                      }

                      try {
                        final response = await http.post(
                          Uri.parse('https://dummyjson.com/auth/login'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode({'username': username, 'password': password}),
                        );

                        if (response.statusCode == 200) {
                          final json = jsonDecode(response.body);
                          final token = json['accessToken'];
                          final userId = json['id'];  

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('token', token);
                          await prefs.setInt('userId', userId);

                          if (!mounted) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error en la autenticación. Verifique sus credenciales e intente nuevamente.')),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error en la autenticación: $e')),
                        );
                      } finally {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      }

                    },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text("Ingresar"),
            ),
          ],
        ),
      ),
    );
  }
}
