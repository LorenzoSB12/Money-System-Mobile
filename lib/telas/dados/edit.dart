import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dados.dart';

class UpdateReceita extends StatefulWidget {
  final String id;
  final String tipo;
  final String titulo;
  final String valor;
  final String descricao;

  const UpdateReceita({
    super.key,
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.valor,
    required this.descricao,
  });

  @override
  State<UpdateReceita> createState() => _UpdateReceitaState();
}

class _UpdateReceitaState extends State<UpdateReceita> {
  final _formKey = GlobalKey<FormState>();
  String _tipo = '';  // Variável interna para armazenar o tipo

  // Controladores dos campos
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final FocusNode _valorFocusNode = FocusNode();
  final TextEditingController _descricaoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.titulo;
    _valorController.text = widget.valor;
    _descricaoController.text = widget.descricao;
    _tipo = widget.tipo;

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
    _tituloController.dispose();
    _valorController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _atualizar() async {
    if (_formKey.currentState!.validate()) {
      // Recupera os dados
      String titulo = _tituloController.text;
      String valor = _valorController.text.replaceAll(RegExp(r'[^0-9,]'), ''); // Mantém vírgula no valor
      String descricao = _descricaoController.text;

      // Cria o corpo da requisição com os nomes de campos ajustados
      Map<String, dynamic> dados = {
        'tipo_de_insercao': _tipo,  // Alterando 'tipo' para 'tipo_de_insercao'
        'titulo': titulo,
        'valor': valor,  // Mantém o valor com vírgula
        'descricao': descricao,
      };

      // Envia os dados para a API
      try {
        final response = await http.put(
          Uri.parse('https://api-money-system-production.up.railway.app/api/financeiro/${widget.id}'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(dados),
        );

        if (mounted) {
          if (response.statusCode == 200) {
            // Sucesso
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Informações atualizadas com sucesso!')),
            );
             Navigator.push(
                  context,
                  // ignore: prefer_const_constructors
                  MaterialPageRoute(builder: (context) => GanhosGastos()),
                );
          } else {
            // Erro
            print('Erro na requisição: ${response.statusCode}'); // Adiciona o status da resposta
            print('Conteúdo da resposta: ${response.body}'); // Imprime o corpo da resposta
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao atualizar: ${response.reasonPhrase}')),
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
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                DropdownButtonFormField<String>(
                  value: _tipo.isNotEmpty && ['GASTO', 'GANHO'].contains(_tipo)
                      ? _tipo
                      : null,  // Use _tipo instead of widget.tipo
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Inserção',
                  ),
                  items: ['GASTO', 'GANHO'].map((String tipo) {
                    return DropdownMenuItem<String>(value: tipo, child: Text(tipo));
                  }).toList(),
                  onChanged: (String? novoTipo) {
                    setState(() {
                      _tipo = novoTipo!;  // Modify _tipo instead of widget.tipo
                    });
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
                  onPressed: _atualizar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Atualizar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}