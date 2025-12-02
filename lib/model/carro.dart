class Carro {
  final String id;
  final int preco;
  final String nome;
  final String tipo;

  Carro({
    required this.id,
    required this.preco,
    required this.nome,
    required this.tipo,
  });

  @override
  String toString() {
    return 'Carro{preco: $preco, nome: $nome, tipo: $tipo}';
  }
}