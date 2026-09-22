import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';

// API pública real: DiceBear (https://www.dicebear.com)
// Gera avatares (imagens) de forma determinística a partir de uma "seed".
// Aqui geramos uma seed nova a cada chamada, para que o avatar mude
// toda vez que o app for aberto.
class AvatarApi {
  final dio = Dio();
  String baseUrl = 'https://api.dicebear.com/10.x';

  Future<Uint8List> gerarAvatarAleatorio({String estilo = 'adventurer'}) async {
    final semente = _gerarSementeAleatoria();

    final response = await dio.get<List<int>>(
      '$baseUrl/$estilo/png',
      queryParameters: {
        'seed': semente,
        'size': 128,
      },
      options: Options(responseType: ResponseType.bytes),
    );

    return Uint8List.fromList(response.data!);
  }

  String _gerarSementeAleatoria() {
    final aleatorio = Random();
    final numero = aleatorio.nextInt(999999);
    final agora = DateTime.now().millisecondsSinceEpoch;
    return '$numero-$agora';
  }
}
