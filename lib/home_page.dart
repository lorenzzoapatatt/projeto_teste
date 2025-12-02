import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:projeto_teste/carroFormPage.dart';
import 'package:projeto_teste/model/carro.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Carro> carros = [];
  
  bool isLoading = true;

  //Inicializa o controlador
  @override
  void initState() {
    
    _getTarefas();
    super.initState();
  }


  Future<void> _getTarefas() async {

    setState(() {
      isLoading = true;
    });

    var dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 30),
        baseUrl: 'https://6912661a52a60f10c82189db.mockapi.io/api/v1',
      ),
    );
    var response = await dio.get('/carros');

    var listData = response.data;
    for (var data in listData) {
      var tarefa = Carro(
        id: data['id'],
        preco: data['preco'],
        nome: data['nome'],
        tipo: data['tipo']
      );
      carros.add(tarefa);
    }

          setState(() {
        isLoading = false;
      });
  }

  //economiza memoria
  @override
  void dispose() {
    super.dispose();
  }

  //Constrói a interface do usuário
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Row(children: [Text(widget.title), const SizedBox(width: 8)]),
      ),
      body: isLoading
      ? Center(child: CircularProgressIndicator())
      : ListView.builder(
        itemCount: carros.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.task),
            title: Text(carros[index].nome),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(carros[index].tipo),
                Text("Preço: ${carros[index].preco}"),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete_outlined),
              onPressed: () => _onPressedDeleteButton(carros[index].id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarTarefa,
        child: Icon(Icons.add),
      ),
    );
  }

  void _adicionarTarefa() {

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CarroFormPage();
        },
      ),
    ).then((_) {
        carros.clear();
        _getTarefas();
      });
    
    // var tarefa = Tarefa(descricao: descricaotarefa, titulo: titulotarefa);
    
    // setState(() {
    //   tarefas.add(tarefa);
    // });
    // controllerTitulo.clear();
    // controllerDescricao.clear();

    
  }
  void _onPressedDeleteButton(String id) async{
    showDialog(context: context, builder: (_){
      return AlertDialog(
        title: Text("Deletar registro"),
        content: Text("Deseja deletar este registro?"),
        actions: [
          TextButton(onPressed: () {
            Navigator.of(context).pop();
          }, child: Text("Cancelar"),),
          ElevatedButton(onPressed: () {
            _excluirTarefa(id);
          }, child: Text("Deletar")),
        ],
      );
    });
  }
  
      void _excluirTarefa(String id) async {
        var dio = Dio(
          BaseOptions(
            connectTimeout: Duration(seconds: 30),
            baseUrl: 'https://6912661a52a60f10c82189db.mockapi.io/api/v1',
          ),
        );
        var response = await dio.delete('/tarefa?$id');
        if (response.statusCode == 200) {

        }else {
          if (!context.mounted) return;
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erro ao excluir")));
        }
      }
}