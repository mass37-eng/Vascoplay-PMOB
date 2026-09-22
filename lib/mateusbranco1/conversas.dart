import 'package:flutter/material.dart';
import 'database_helper_atendimentos.dart';
import 'chat_screen.dart';
import 'api_service.dart';

void main() => runApp(const ConversasApp());

class ConversasApp extends StatelessWidget {
  const ConversasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meus Atendimentos',
      home: const ConversasScreen(),
    );
  }
}

class ConversasScreen extends StatefulWidget {
  const ConversasScreen({super.key});

  @override
  State<ConversasScreen> createState() => _ConversasScreenState();
}

class _ConversasScreenState extends State<ConversasScreen> {
  final _dbHelper = DatabaseHelperAtendimentos.instance;

  List<Atendimento> _atendimentos = [];
  bool _carregando = true;

  late Future<List<Map<String, dynamic>>> _futureAtendentes;

  @override
  void initState() {
    super.initState();
    _carregarAtendimentos();
    _futureAtendentes = FakeApiService.buscarAtendentes();
  }

  Future<void> _carregarAtendimentos() async {
    final lista = await _dbHelper.getAllAtendimentos();
    setState(() {
      _atendimentos = lista;
      _carregando = false;
    });
  }

  String _proximoNumero() => '${_atendimentos.length + 1}';

  Future<void> _abrirNovoAtendimento() async {
    final assuntoController = TextEditingController();

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo atendimento'),
        content: TextField(
          controller: assuntoController,
          decoration: const InputDecoration(labelText: 'Qual o assunto?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (assuntoController.text.trim().isEmpty) return;
              Navigator.pop(context, true);
            },
            child: const Text('Abrir'),
          ),
        ],
      ),
    );

    if (confirmou != true) return;

    final atendimento = Atendimento(
      numero: _proximoNumero(),
      assunto: assuntoController.text.trim(),
      dataAbertura: DateTime.now().toIso8601String(),
    );

    await _dbHelper.insertAtendimento(atendimento);
    await _carregarAtendimentos();
  }

  Future<void> _abrirChat(Atendimento atendimento) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(atendimento: atendimento),
      ),
    );
    await _carregarAtendimentos();
  }

  Future<void> _excluirAtendimento(int id) async {
    await _dbHelper.deleteMensagensDoAtendimento(id);
    await _dbHelper.deleteAtendimento(id);
    await _carregarAtendimentos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Atendimentos')),
      body: Column(
        children: [
          _textoAtendentes(),
          Expanded(child: _buildBody()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirNovoAtendimento,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _textoAtendentes() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureAtendentes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Carregando atendentes...');
        }
        if (snapshot.hasError) {
          return const Text('Não foi possível carregar os atendentes.');
        }

        final atendentes = snapshot.data ?? [];
        final nomes = <String>[];
        for (final atendente in atendentes) {
          final nome = atendente['host'] ?? atendente['local'] ?? 'Sem nome';
          nomes.add(nome);
        }
        return Text('Atendentes: ${nomes.join(', ')}');
      },
    );
  }

  Widget _buildBody() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_atendimentos.isEmpty) {
      return const Center(
        child: Text('Você ainda não abriu nenhum atendimento.'),
      );
    }
    return ListView.builder(
      itemCount: _atendimentos.length,
      itemBuilder: (context, index) {
        final atendimento = _atendimentos[index];
        return ListTile(
          title: Text('Atendimento ${atendimento.numero}'),
          subtitle: Text(atendimento.assunto),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _excluirAtendimento(atendimento.id!),
          ),
          onTap: () => _abrirChat(atendimento),
        );
      },
    );
  }
}
