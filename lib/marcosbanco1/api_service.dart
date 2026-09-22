import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {

  static const String _baseUrl =
      'https://my-json-server.typicode.com/SEU_USUARIO_GITHUB/SEU_REPOSITORIO';

  /// Busca a lista de clientes cadastrados na fake API.
  static Future<List<Map<String, dynamic>>> buscarClientes() async {
    final response = await http.get(Uri.parse('$_baseUrl/clientes_cadastrados'));

    if (response.statusCode != 200) {
      throw Exception('Falha ao buscar clientes (status ${response.statusCode})');
    }

    final List<dynamic> dados = jsonDecode(response.body);
    return dados.cast<Map<String, dynamic>>();
  }

  /// Verifica se existe um cliente com [email] e [senha] iguais aos
  /// cadastrados na fake API. Retorna true se o login funcionar(não vai(eu acho)).
  static Future<bool> validarLogin(String email, String senha) async {
    final clientes = await buscarClientes();

    return clientes.any((cliente) =>
    cliente['email'] == email && cliente['senha'] == senha);
  }

  /// Busca o cliente completo (nome, plano, etc.) a partir do e-mail.
  /// Retorna null se não encontrar(não vai(mas acho que pode funcionar(tudo depende se der pra arrumar a tempo(eu não tenho tempo)))).
  static Future<Map<String, dynamic>?> buscarClientePorEmail(String email) async {
    final clientes = await buscarClientes();
    try {
      return clientes.firstWhere((cliente) => cliente['email'] == email);
    } catch (_) {
      return null;
    }
  }
}
