import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CarroEditPage extends StatefulWidget {
  final String id;

  const CarroEditPage({super.key, required this.id});

  @override
  State<CarroEditPage> createState() => _CarroEditPageState();
}

class _CarroEditPageState extends State<CarroEditPage> {
  late TextEditingController controllerPreco;
  late TextEditingController controllerNome;
  late TextEditingController controllerTipo;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controllerPreco = TextEditingController();
    controllerNome = TextEditingController();
    controllerTipo = TextEditingController();
    _carregarCarro();
  }

  @override
  void dispose() {
    controllerPreco.dispose();
    controllerNome.dispose();
    controllerTipo.dispose();
    super.dispose();
  }

  Dio get _dio => Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          baseUrl: 'https://6912661a52a60f10c82189db.mockapi.io/api/v1',
        ),
      );

  Future<void> _carregarCarro() async {
    setState(() => isLoading = true);

    try {
      final response = await _dio.get('/carros/${widget.id}');
      final data = response.data;

      // Preenche os campos (aceita preco vindo como int ou string)
      controllerPreco.text = (data['preco'] ?? '').toString();
      controllerNome.text = (data['nome'] ?? '').toString();
      controllerTipo.text = (data['tipo'] ?? '').toString();

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar carro para edição")),
      );
      Navigator.of(context).pop();
    }
  }

  String? _validaPreco(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return "Você precisa digitar um preço";
    final n = int.tryParse(v);
    if (n == null) return "Preço inválido (use apenas números)";
    return null;
  }

  String? _validaNaoVazio(String? value, String msg) {
    if (value == null || value.trim().isEmpty) return msg;
    return null;
  }

  Future<void> _salvarEdicao() async {
    if (formKey.currentState?.validate() != true) return;

    final preco = int.parse(controllerPreco.text.trim());
    final nome = controllerNome.text.trim();
    final tipo = controllerTipo.text.trim();

    try {
      final response = await _dio.put(
        '/carros/${widget.id}',
        data: {
          'preco': preco,
          'nome': nome,
          'tipo': tipo,
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        Navigator.of(context).pop(true); // avisa que editou
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao salvar edição")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao salvar edição")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Carro")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerPreco,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Preço',
                      ),
                      validator: _validaPreco,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerNome,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome',
                      ),
                      validator: (v) => _validaNaoVazio(v, "Você precisa digitar um nome"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controllerTipo,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Tipo',
                      ),
                      validator: (v) => _validaNaoVazio(v, "Você precisa digitar um tipo"),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _salvarEdicao,
                    icon: const Icon(Icons.save_outlined),
                    label: const Text("Salvar Alterações"),
                  ),
                ],
              ),
            ),
    );
  }
}
