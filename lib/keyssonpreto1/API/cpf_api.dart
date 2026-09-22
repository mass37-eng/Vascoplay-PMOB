import 'package:dio/dio.dart';

import '../domain/sugestao_cpf.dart';


class CpfApi {
  final dio = Dio();
  String baseUrl = 'https://fakerapi.it/api/v2';

  Future<List<SugestaoCpf>> listarSugestoes({int quantidade = 5}) async {
    final response = await dio.get(
      '$baseUrl/custom',
      queryParameters: {
        '_quantity': quantidade,
        '_locale': 'pt_BR',
        'nome': 'name',
        'documento': 'randomNumber',
      },
    );

    List<SugestaoCpf> lista = [];

    if (response.statusCode == 200) {
      for (var json in response.data['data']) {
        SugestaoCpf sugestao = SugestaoCpf.fromJson(json);
        lista.add(sugestao);
      }
    }

    return lista;
  }
}