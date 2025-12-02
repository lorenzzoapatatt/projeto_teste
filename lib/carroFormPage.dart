import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CarroFormPage extends StatefulWidget {
  const CarroFormPage({super.key});

  @override
  State<CarroFormPage> createState() => _TarefaFormPageState();
}

class _TarefaFormPageState extends State<CarroFormPage> {

  //Controlador para o campo de texto
  late TextEditingController controllerPreco;
  late TextEditingController controllerNome;
  late TextEditingController controllerTipo;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  @override
  void initState(){
    controllerPreco = TextEditingController();
    controllerNome = TextEditingController();
    controllerTipo = TextEditingController();

    super.initState();
  }

  //economiza memoria
  @override
  void dispose() {
    controllerPreco.dispose();
    controllerNome.dispose();
    controllerTipo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Cadastrar Tarefa"),),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerPreco,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite o preço para o carro',
                ),
                validator: (value) => _validaCampoPreco(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerNome,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite o nome do carro',
                ),
                validator: (value) => _validaCampoNome(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerTipo,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Digite o tipo do carro',
                ),
                validator: (value) => _validaCampoTipo(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _salvarTarefa,
              label: Text("Salvar Tarefa"),
              icon: Icon(Icons.save_alt_outlined),
              )
            ],
                    ),
          ),
    );


  }
    String? _validaCampoPreco() 
    {
      var descricaotarefa = controllerPreco.text;

      if (descricaotarefa.trim().isEmpty) {
        return "Voce precisa digitar um preço";
      }
      
      return null;
    }

     String? _validaCampoNome() 
    {
      var descricaotarefa = controllerNome.text;

      if (descricaotarefa.trim().isEmpty) {
        return "Voce precisa digitar um nome";
      }
      
      return null;
    }

    String? _validaCampoTipo() 
    {
      var descricaotarefa = controllerTipo.text;

      if (descricaotarefa.trim().isEmpty) {
        return "Voce precisa digitar um tipo";
      }
      
      return null;
    }

    Future<void> _salvarTarefa() async {
      var precotarefa = controllerPreco.text;
      var nometarefa = controllerNome.text;
      var tipotarefa = controllerTipo.text;
    
    if (formKey.currentState?.validate() == true) {
      //Salvar
      var dio = Dio(
        BaseOptions(
          connectTimeout: Duration(seconds: 30),
          baseUrl: 'https://6912661a52a60f10c82189db.mockapi.io/api/v1',
        ),
      );

      var response = await dio.post(
        '/tarefa',
        data: {'titulo': precotarefa, 'descrição': nometarefa, 'sla': tipotarefa},
      );

      if (context.mounted) Navigator.pop(context);

      Navigator.of(context).pop();
    }
  }
}