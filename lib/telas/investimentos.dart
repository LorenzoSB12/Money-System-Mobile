import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ganhos_gastos.dart';
import 'financiamento.dart';
import 'tela_inicial.dart';
import 'dados/dados.dart';

class Investimentos extends StatefulWidget {
  const Investimentos({super.key});

  @override
  InvestimentosState createState() => InvestimentosState();
}

class InvestimentosState extends State<Investimentos> {
  Map<String, String> stockPrices = {}; // Mapa para armazenar os preços das ações
  final String apiKey = 'NDNC5L8E6LQWJ6WN'; // Substitua pela sua chave de API da Alpha Vantage
  final List<String> stockSymbols = ['AAPL', 'GOOGL', 'MSFT']; // Lista de símbolos das ações

  // Função para buscar os dados de várias ações
  Future<void> fetchStockData() async {
    for (String symbol in stockSymbols) {
      final url =
          'https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=$symbol&interval=5min&apikey=$apiKey';

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          // Se a resposta for bem-sucedida, analisa os dados JSON
          var data = jsonDecode(response.body);

          // Acessando o preço da última ação registrada
          var lastPrice = data['Time Series (5min)']?.values?.first?['4. close'] ?? 'Erro';

          setState(() {
            stockPrices[symbol] = lastPrice;
          });
        } else {
          setState(() {
            stockPrices[symbol] = "Erro ao carregar dados.";
          });
        }
      } catch (e) {
        setState(() {
          stockPrices[symbol] = "Erro de conexão.";
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStockData(); // Carrega os dados da API ao iniciar a tela
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investimentos'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer( // Drawer adicionado
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Preços das Ações',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: stockSymbols.length,
                itemBuilder: (context, index) {
                  String symbol = stockSymbols[index];
                  String? price = stockPrices[symbol];
                  bool isError = price == null || price.contains("Erro");

                  return ListTile(
                    title: Text(
                      symbol,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue, // Cor azul para o nome da ação
                      ),
                    ),
                    subtitle: Text(
                      price ?? 'Carregando...',
                      style: TextStyle(
                        fontSize: 18,
                        color: isError ? Colors.red : Colors.green, // Vermelho para erros, verde para sucesso
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: fetchStockData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Atualizar Dados"),
            ),
          ],
        ),
      ),
    );
  }
}
