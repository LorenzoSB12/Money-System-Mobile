import 'package:flutter/material.dart';
import 'dart:math';  // Importação para usar o método pow

// Importe as outras páginas para a navegação
import 'investimentos.dart';
import 'ganhos_gastos.dart';
import 'tela_inicial.dart';
import 'dados/dados.dart';

class SimuleFinanciamento extends StatefulWidget {
  const SimuleFinanciamento({super.key});

  @override
  SimuleFinanciamentoState createState() => SimuleFinanciamentoState();
}

class SimuleFinanciamentoState extends State<SimuleFinanciamento> {
  final TextEditingController valorController = TextEditingController();
  final TextEditingController jurosController = TextEditingController();
  final TextEditingController mesesController = TextEditingController();

  double valorFinal = 0.0;

  // Função que será chamada para calcular o financiamento
  void calcularFinanciamento() {
    double valor = double.tryParse(valorController.text) ?? 0.0;
    double juros = (double.tryParse(jurosController.text.replaceAll(',', '.')) ?? 0.0) / 100; // Substituindo vírgula por ponto
    int meses = int.tryParse(mesesController.text) ?? 0;

    // Fórmula de juros compostos: ValorFinal = ValorInicial * (1 + juros)^meses
    setState(() {
      valorFinal = valor * pow(1 + juros, meses);  // Usando a função pow da biblioteca dart:math
    });
  }

  // Função para formatar o valor com vírgula ao clicar fora da box
  void formatarValor() {
    setState(() {
      String formatted = valorController.text.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ','); // Adicionando vírgula para separar milhar
      valorController.text = formatted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simule Financiamento"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      // Adicionando o Drawer aqui
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaInicial()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.attach_money, color: Colors.black),
              title: const Text('Formulário Receita'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Campo de texto para valor inicial
            TextField(
              controller: valorController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Valor inicial (R\$)",
                border: OutlineInputBorder(),
              ),
              onEditingComplete: formatarValor,  // Formatar o valor ao sair da caixa
            ),
            const SizedBox(height: 16),
            
            // Campo de texto para taxa de juros
            TextField(
              controller: jurosController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Taxa de juros (%)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Converter vírgula para ponto enquanto o usuário digita
                if (value.contains(',')) {
                  jurosController.text = value.replaceAll(',', '.');
                  jurosController.selection = TextSelection.collapsed(offset: jurosController.text.length);
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Campo de texto para quantidade de meses
            TextField(
              controller: mesesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Quantidade de meses",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Botão de calcular
            ElevatedButton(
              onPressed: calcularFinanciamento,
              child: const Text("Calcular"),
            ),
            const SizedBox(height: 16),
            
            // Exibição do valor final calculado
            Text(
              "Valor final: R\$ ${valorFinal.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
