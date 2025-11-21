class Carro {
  final int preco;
  final String nome;
  final String tipo;

  Carro({
    required this.preco,
    required this.nome,
    required this.tipo,
  });

  @override
  String toString() {
    return 'Carro{preco: $preco, nome: $nome, tipo: $tipo}';
  }
}