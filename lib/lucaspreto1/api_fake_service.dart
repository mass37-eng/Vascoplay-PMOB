// Consumo da API FAKE (My JSON Server), baseada na estrutura do repositorio
// https://github.com/tarsisms/fake_api
//
// COMO PUBLICAR A SUA PROPRIA API FAKE:
// 1. Crie um repositorio PUBLICO no seu GitHub chamado "fake_api".
// 2. Suba na raiz dele o arquivo "fake_api/db.json" que esta neste projeto.
// 3. A API ficara disponivel em:
//      https://my-json-server.typicode.com/SEU_USUARIO/fake_api
// 4. Troque a constante "usuarioGithub" abaixo pelo seu usuario do GitHub.
//
// Endpoints gerados a partir do db.json:
//   GET /cartoes            -> lista os cartoes presente
//   GET /cartoes/1          -> retorna o cartao de id 1
//   GET /formasPagamento    -> lista as formas de pagamento
//   GET /users              -> usuarios (usados pelo colega do login)

import 'dart:convert';
import 'package:http/http.dart' as http;


class CartaoPresenteApi {
  final int id;
  final String titulo;
  final double preco;
  final String descricao;
  final int validadeMeses;
  final List<String> beneficios;

  const CartaoPresenteApi({
    required this.id,
    required this.titulo,
    required this.preco,
    required this.descricao,
    required this.validadeMeses,
    required this.beneficios,
  });

  factory CartaoPresenteApi.fromJson(Map<String, dynamic> json) {
    return CartaoPresenteApi(
      id: json['id'] as int,
      titulo: json['titulo'] as String? ?? 'Sem titulo',
      preco: (json['preco'] as num?)?.toDouble() ?? 0.0,
      descricao: json['descricao'] as String? ?? '',
      validadeMeses: (json['validadeMeses'] as num?)?.toInt() ?? 12,
      beneficios: (json['beneficios'] as List<dynamic>? ?? [])
          .map((b) => b.toString())
          .toList(),
    );
  }
}

class FormaPagamentoApi {
  final int id;
  final String nome;
  final int parcelas;
  final double taxa;

  const FormaPagamentoApi({
    required this.id,
    required this.nome,
    required this.parcelas,
    required this.taxa,
  });

  factory FormaPagamentoApi.fromJson(Map<String, dynamic> json) {
    return FormaPagamentoApi(
      id: json['id'] as int,
      nome: json['nome'] as String? ?? 'Pix',
      parcelas: (json['parcelas'] as num?)?.toInt() ?? 1,
      taxa: (json['taxa'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ApiFakeService {
  // >>> TROQUE AQUI PELO SEU USUARIO DO GITHUB <<<
  static const String usuarioGithub = 'Lucasadiel';
  static const String repositorio = 'fake_api';

  static const String baseUrl =
      'https://my-json-server.typicode.com/$usuarioGithub/$repositorio';

  Future<List<CartaoPresenteApi>> buscarCartoes() async {
    final resposta = await http
        .get(Uri.parse('$baseUrl/cartoes'))
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 200) {
      throw Exception(
        'Falha ao carregar os cartoes (codigo ${resposta.statusCode}).',
      );
    }

    // utf8.decode evita problemas com acentuacao
    final List<dynamic> lista = jsonDecode(utf8.decode(resposta.bodyBytes));
    return lista
        .map((item) => CartaoPresenteApi.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<CartaoPresenteApi> buscarCartaoPorId(int id) async {
    final resposta = await http
        .get(Uri.parse('$baseUrl/cartoes/$id'))
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 200) {
      throw Exception('Cartao $id nao encontrado na API Fake.');
    }

    final Map<String, dynamic> json =
        jsonDecode(utf8.decode(resposta.bodyBytes));
    return CartaoPresenteApi.fromJson(json);
  }


  Future<List<FormaPagamentoApi>> buscarFormasPagamento() async {
    final resposta = await http
        .get(Uri.parse('$baseUrl/formasPagamento'))
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 200) {
      throw Exception(
        'Falha ao carregar as formas de pagamento (codigo ${resposta.statusCode}).',
      );
    }

    final List<dynamic> lista = jsonDecode(utf8.decode(resposta.bodyBytes));
    return lista
        .map((item) => FormaPagamentoApi.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
