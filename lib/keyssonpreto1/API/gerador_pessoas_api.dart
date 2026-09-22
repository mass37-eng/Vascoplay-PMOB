import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/pessoa_aleatoria.dart';


class GeradorPessoasApi {
  static const String _token = '28433|O44SUGK44iMQcyuckv8mHLJaNoktKUdA';
  final String _baseUrl = 'https://api.invertexto.com/v1/gerador-pessoas';

  Future<List<PessoaAleatoria>> listarPessoas({int quantidade = 5}) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'token': _token,
      'pais': 'BR',
      'qtd': quantidade.toString(),
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Erro ao consultar a API de geração de pessoas '
            '(status ${response.statusCode}): ${response.body}',
      );
    }

    final dynamic dados = jsonDecode(response.body);


    final List<dynamic> itens = dados is List ? dados : [dados];

    return itens
        .map((json) => PessoaAleatoria.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}