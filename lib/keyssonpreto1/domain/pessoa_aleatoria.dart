class PessoaAleatoria {
  late String nome;
  late String cpf;
  late String email;
  late String cidade;
  late String estado;

  PessoaAleatoria({
    required this.nome,
    required this.cpf,
    required this.email,
    required this.cidade,
    required this.estado,
  });


  PessoaAleatoria.fromJson(Map<String, dynamic> json) {
    nome = json['nome']?.toString() ?? '';
    cpf = json['cpf']?.toString() ?? '';
    email = json['email']?.toString() ?? '';
    cidade = json['cidade']?.toString() ?? '';
    estado = json['estado']?.toString() ?? '';
  }
}