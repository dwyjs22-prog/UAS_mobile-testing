import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/pasien_list_page.dart';
import 'pages/pasien_add_page.dart';
import 'pages/pasien_edit_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),

      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(), // ⬅️ INI PENTING
        '/pasien': (context) => const PasienListPage(),
        '/add': (context) => const PasienAddPage(),
        '/edit': (context) => const PasienEditPage(),
      },
    );
  }
}