import 'dart:convert';
import 'package:http/http.dart' as http;

class Propriedade {
  final String id, total, avaliacao, dates, local, host, urlImagem;

  Propriedade({
    required this.id,
    required this.total,
    required this.avaliacao,
    required this.dates,
    required this.local,
    required this.host,
    required this.urlImagem,
  });

  factory Propriedade.fromMap(Map<String, dynamic> map) => Propriedade(
    id: map['id'],
    total: map['total'],
    avaliacao: map['avaliacao'],
    dates: map['dates'],
    local: map['local'],
    host: map['host'],
    urlImagem: map['urlImagem'],
  );
}

class PropriedadeApiService {
  static const _url = 'https://my-json-server.typicode.com/tarsisms/fake-api/propriedades';

  Future<List<Propriedade>> buscarPropriedades() async {
    final resposta = await http.get(Uri.parse(_url));
    if (resposta.statusCode != 200) throw Exception('Erro ao buscar propriedades.');

    final dados = jsonDecode(resposta.body) as List;
    return dados.map((p) => Propriedade.fromMap(p)).toList();
  }
}
