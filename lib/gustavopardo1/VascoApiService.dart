import 'dart:convert';
import 'package:http/http.dart' as http;

class Time {
  final String nome, escudo, estadio, descricao;

  Time({required this.nome, required this.escudo, required this.estadio, required this.descricao});

  factory Time.fromMap(Map<String, dynamic> map) => Time(
    nome: map['strTeam'] ?? '',
    escudo: map['strTeamBadge'] ?? '',
    estadio: map['strStadium'] ?? '',
    descricao: map['strDescriptionPT'] ?? map['strDescriptionEN'] ?? '',
  );
}

class VascoApiService {
  static const _url =
      'https://www.thesportsdb.com/api/v1/json/3/searchteams.php?t=Vasco%20da%20Gama';

  Future<Time> buscarTime() async {
    final resposta = await http.get(Uri.parse(_url));
    if (resposta.statusCode != 200) throw Exception('Erro ao buscar dados do time.');

    final times = jsonDecode(resposta.body)['teams'] as List?;
    if (times == null || times.isEmpty) throw Exception('Time não encontrado.');

    return Time.fromMap(times.first);
  }
}
