// Importações
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tela_inicial.dart';
import 'investimentos.dart';
import 'financiamento.dart';
import 'dados/dados.dart';

class InserirDespesasGanhos extends StatefulWidget {
  const InserirDespesasGanhos({super.key});

  @override
  State<InserirDespesasGanhos> createState() => _InserirDespesasGanhosState();
}

class _InserirDespesasGanhosState extends State<InserirDespesasGanhos> {
  final _formKey = GlobalKey<FormState>();

  // Controladores dos campos
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final FocusNode _valorFocusNode = FocusNode();
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _valorFocusNode.addListener(_onValorFocusChange);
  }

  // Listener para verificar mudança de foco
  void _onValorFocusChange() {
    if (!_valorFocusNode.hasFocus) {
      // Formata o valor quando o campo perde o foco
      String novoValor = _valorController.text.replaceAll(RegExp(r'[^0-9]'), '');
      double valor = double.tryParse(novoValor) ?? 0;
      _valorController.text =
          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(valor / 100);
    }
  }

  @override
  void dispose() {
    _valorFocusNode.removeListener(_onValorFocusChange);
    _valorFocusNode.dispose();
    _valorController.dispose();
    super.dispose();
  }

  String _tipo = 'GASTO'; // Opção inicial

  

  // Função para salvar as informações
  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      // Recupera os dados
      String tipo = _tipo;
      String titulo = _tituloController.text;

      // Remove qualquer formatação do valor, como vírgulas ou símbolos de moeda
      String valor = _valorController.text.replaceAll(RegExp(r'[^0-9]'), ''); 

      // Converte o valor para double em centavos (valor sem vírgula)
      double valorFormatado = double.tryParse(valor) ?? 0.0; 

      String descricao = _descricaoController.text;

      // Cria o corpo da requisição com o valor sem formatação
      Map<String, dynamic> dados = {
        'tipo_de_insercao': tipo,
        'titulo': titulo,
        'valor': valorFormatado.toString(),  // Envia o valor como número (sem formatação)
        'descricao': descricao,
      };

      // Envia os dados para a API
      try {
        final response = await http.post(
          Uri.parse('https://api-money-system-production.up.railway.app/api/financeiro/'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(dados),
        );

        if (mounted) {
          if (response.statusCode == 200 || response.statusCode == 201) {
            // Mensagem de sucesso
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Receita adicionada com sucesso!')),
            );
          } else {
            // Mensagem de erro
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao salvar: ${response.statusCode}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro de conexão: $e')),
          );
        }
      }

      // Limpa os campos
      _tituloController.clear();
      _valorController.clear();
      _descricaoController.clear();
      setState(() {
        _tipo = 'GASTO'; // Reseta a seleção de tipo
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserir Despesas/Ganhos'),
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
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
      body: Container(
        color: Colors.white, // Fundo branco
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: _tipo,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Inserção',
                  ),
                  items: ['GASTO', 'GANHO'].map((String tipo) {
                    return DropdownMenuItem<String>(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (String? novoTipo) {
                    setState(() {
                      _tipo = novoTipo!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, selecione um tipo.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um título.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _valorController,
                  focusNode: _valorFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira um valor.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira uma descrição.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _salvar,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
