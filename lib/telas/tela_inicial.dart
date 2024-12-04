import 'package:flutter/material.dart';
import 'tela_principal.dart';

class TelaInicial extends StatelessWidget {
  const TelaInicial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,  // Fundo branco
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem de dinheiro voando
            Image.asset(
              'assets/images/dinheirovoando.png', // Substitua pelo caminho correto da imagem
              width: 150,
              height: 150,
            ),
            const SizedBox(height: 40), // Espaçamento
            // Botão "Entrar"
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Cor do botão
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Navegar para a tela principal ao clicar no botão
                Navigator.push(
                  context,
                  // ignore: prefer_const_constructors
                  MaterialPageRoute(builder: (context) => TelaPrincipal()),
                );
              },
              child: const Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
