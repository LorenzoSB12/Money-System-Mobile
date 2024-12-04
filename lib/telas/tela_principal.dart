import 'package:flutter/material.dart';
import 'investimentos.dart';
import 'ganhos_gastos.dart';
import 'dados/dados.dart';
import 'financiamento.dart';

class TelaPrincipal extends StatelessWidget {
  const TelaPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaPrincipal()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.black),
              title: const Text('Inserir ganhos/gastos'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InserirDespesasGanhos()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart, color: Colors.black),
              title: const Text('Investimentos'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Investimentos()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.black),
              title: const Text('Dados'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const GanhosGastos()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.black),
              title: const Text('Financiamento'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SimuleFinanciamento()),
                );
              },
            ),
          ],
        ),
      ),
      body: const GanhosGastos(),
    );
  }
}
