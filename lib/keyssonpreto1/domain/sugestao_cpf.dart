class SugestaoCpf {
  late String nome;
  late String cpf;

  SugestaoCpf({required this.nome, required this.cpf});


  SugestaoCpf.fromJson(Map<String, dynamic> json) {
    nome = json['nome'];
    cpf = _formatarComoCpf(json['documento']);
  }

  static String _formatarComoCpf(dynamic numero) {
    String digitos = numero.toString().replaceAll(RegExp(r'[^0-9]'), '');
    digitos = digitos.padLeft(11, '0');
    if (digitos.length > 11) {
      digitos = digitos.substring(digitos.length - 11);
    }
    return '${digitos.substring(0, 3)}.${digitos.substring(3, 6)}.'
        '${digitos.substring(6, 9)}-${digitos.substring(9, 11)}';
  }
}