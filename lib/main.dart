import 'package:flutter/material.dart';
import 'telas/tela_inicial.dart'; // Importe a tela inicial

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle Financeiro',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const TelaInicial(), // Defina a tela inicial
    );
  }
}

