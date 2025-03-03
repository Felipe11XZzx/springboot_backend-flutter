import 'package:flutter/material.dart';
import 'screens/pantallaprincipal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto Final Coldman S.A',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 33, 150, 243)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Pantalla principal'),
    );
  }
}
