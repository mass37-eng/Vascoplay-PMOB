import 'package:dio/dio.dart';

import '../domain/cliente_camarote.dart';

class CamaroteFakeApi {
  final dio = Dio();
  String baseUrl =
      'https://my-json-server.typicode.com/mass37-eng/Vascoplay-PMOB';

  Future<List<ClienteCamarote>> listarClientes() async {
    final response = await dio.get('$baseUrl/clientes_cadastrados');

    List<ClienteCamarote> lista = [];

    if (response.statusCode == 200) {
      for (var json in response.data) {
        ClienteCamarote cliente = ClienteCamarote.fromJson(json);
        lista.add(cliente);
      }
    }

    return lista;
  }
}