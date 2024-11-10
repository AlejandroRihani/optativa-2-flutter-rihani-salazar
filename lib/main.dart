import 'package:flutter/material.dart';
import 'package:proyecto_alejandro_rihani/routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo de Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.login, 
      routes: AppRoutes.routes, 
    );
  }
}
