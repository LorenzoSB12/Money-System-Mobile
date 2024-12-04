import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../investimentos.dart';
import '../ganhos_gastos.dart';
import '../financiamento.dart';
import '../tela_inicial.dart';
import 'edit.dart';

class GanhosGastos extends StatefulWidget {
  const GanhosGastos({super.key});

  @override
  State<GanhosGastos> createState() => _GanhosGastosState();
}

class _GanhosGastosState extends State<GanhosGastos> {
  List<Map<String, dynamic>> registros = [];
  final String apiUrl = 'https://api-money-system-production.up.railway.app/api/financeiro/';

  @override
  void initState() {
    super.initState();
    _loadRegistros();
  }

  Future<void> _loadRegistros() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          registros = data.map((registro) {
            return {
              'tipo': registro['tipo_de_insercao'] ?? 'Tipo não disponível',
              'titulo': registro['titulo'] ?? 'Título não disponível',
              'valor': registro['valor'] ?? 0.0,
              'descricao': registro['descricao'] ?? 'Descrição não disponível',
              'id': registro['id'] ?? 0,
            };
          }).toList();
        });
      } else {
        _showSnackBar('Erro ao carregar registros: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Erro de conexão: $e');
    }
  }

  Future<void> _deleteRegistro(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl$id'));
      if (response.statusCode == 200) {
        setState(() {
          registros.removeWhere((registro) => registro['id'] == id);
        });
        _showSnackBar('Registro excluído com sucesso!');
      } else {
        _showSnackBar('Erro ao excluir registro: ${response.body}');
      }
    } catch (e) {
      _showSnackBar('Erro de conexão: $e');
    }
  }

  void _editRegistro(Map<String, dynamic> registro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarRegistroScreen(
          registro: registro, 
        ),
      ),
    ).then((_) => _loadRegistros());
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Color getColor(String tipo) {
    if (tipo == "GASTO") {
      return Colors.red.withOpacity(0.3);
    } else if (tipo == "GANHO") {
      return Colors.green.withOpacity(0.3);
    }
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganhos e Gastos'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
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
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            DataTable(
              columns: const [
                DataColumn(label: Text('Tipo')),
                DataColumn(label: Text('Título')),
                DataColumn(label: Text('Valor')),
                DataColumn(label: Text('Descrição')),
                DataColumn(label: Text('Ações')),
              ],
              rows: registros.map((registro) {
                return DataRow(cells: [
                  DataCell(
                      Container(
                        color: getColor(registro['tipo']),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(registro['tipo'] ?? 'Tipo não disponível'),
                      ),
                    ),
                  DataCell(Text(registro['titulo'] ?? 'Título não disponível')),
                  DataCell(Text(registro['valor']?.toString() ?? 'Valor não disponível')),
                  DataCell(Text(registro['descricao'] ?? 'Descrição não disponível')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editRegistro(registro),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteRegistro(registro['id']),
                      ),
                    ],
                  )),
                ]);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class EditarRegistroScreen extends StatelessWidget {
  final Map<String, dynamic> registro;

  const EditarRegistroScreen({super.key, required this.registro});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Registro'),
        backgroundColor: Colors.green,
      ),
      body: UpdateReceita(
        id: registro['id'].toString(),
        tipo: registro['tipo'] ?? '',
        titulo: registro['titulo'] ?? '',
        valor: registro['valor'].toString(),
        descricao: registro['descricao'] ?? '',
      ),
    );
  }
}
