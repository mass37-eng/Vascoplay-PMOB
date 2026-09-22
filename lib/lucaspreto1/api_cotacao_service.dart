// Consumo da API PUBLICA REAL: AwesomeAPI (Economia / Cotacoes)
// Documentacao: https://docs.awesomeapi.com.br/api-de-moedas
//
// Endpoint usado:
//   GET https://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL,GBP-BRL,ARS-BRL
//
// A API e gratuita e nao exige cadastro nem chave para uso basico.
// Ela e usada aqui para mostrar quanto custa o Cartao Presente do Vasco
// para o torcedor que mora fora do Brasil.

import 'dart:convert';
import 'package:http/http.dart' as http;


class Cotacao {
  final String code;
  final String codein;
  final String name;
  final double bid;
  final double ask;
  final double high;
  final double low;
  final double pctChange;
  final String createDate;

  const Cotacao({
    required this.code,
    required this.codein,
    required this.name,
    required this.bid,
    required this.ask,
    required this.high,
    required this.low,
    required this.pctChange,
    required this.createDate,
  });


  factory Cotacao.fromJson(Map<String, dynamic> json) {
    double paraDouble(dynamic valor) =>
        double.tryParse(valor?.toString() ?? '') ?? 0.0;

    return Cotacao(
      code: json['code'] as String? ?? '',
      codein: json['codein'] as String? ?? '',
      name: json['name'] as String? ?? '',
      bid: paraDouble(json['bid']),
      ask: paraDouble(json['ask']),
      high: paraDouble(json['high']),
      low: paraDouble(json['low']),
      pctChange: paraDouble(json['pctChange']),
      createDate: json['create_date'] as String? ?? '',
    );
  }

  double converterDeReais(double valorEmReais) {
    if (bid <= 0) return 0;
    return valorEmReais / bid;
  }

  String get nomeCurto => name.split('/').first.trim();
}

class ApiCotacaoService {
  static const String baseUrl = 'https://economia.awesomeapi.com.br/json/last';

  static const List<String> moedas = [
    'USD-BRL',
    'EUR-BRL',
    'GBP-BRL',
    'ARS-BRL',
  ];


  Future<List<Cotacao>> buscarCotacoes() async {
    final url = '$baseUrl/${moedas.join(',')}';

    final resposta =
        await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 200) {
      throw Exception(
        'Falha ao consultar as cotacoes (codigo ${resposta.statusCode}).',
      );
    }

    final Map<String, dynamic> json =
        jsonDecode(utf8.decode(resposta.bodyBytes));

    return json.values
        .map((item) => Cotacao.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
