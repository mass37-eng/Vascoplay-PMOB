class ClienteCamarote {
  late int id;
  late String nome;
  late String cpf;
  late String plano;

  ClienteCamarote({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.plano,
  });

  ClienteCamarote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cpf = json['cpf'];
    plano = json['plano'];
  }
}