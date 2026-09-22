import 'dart:convert';
import 'package:http/http.dart' as http;

class AdviceApiService {
  static const String _url = 'https://api.adviceslip.com/advice';

  static Future<String> buscarDica() async {
    final resposta = await http.get(Uri.parse(_url));

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body);
      return dados['slip']['advice'];
    } else {
      throw Exception('Erro ao buscar dica (status ${resposta.statusCode})');
    }
  }
}

class FakeApiService {
  static const String _baseUrl =
      'https://my-json-server.typicode.com/tarsisms/fake_api';

  static const String _recurso = 'propriedades';

  static Future<List<Map<String, dynamic>>> buscarAtendentes() async {
    final resposta = await http.get(Uri.parse('$_baseUrl/$_recurso'));

    if (resposta.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(resposta.body);

      final List<Map<String, dynamic>> atendentes = [];
      for (final item in lista) {
        atendentes.add(item);
      }
      return atendentes;
    } else {
      throw Exception(
          'Erro ao buscar atendentes (status ${resposta.statusCode})');
    }
  }
}
