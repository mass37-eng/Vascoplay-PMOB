import 'package:flutter/material.dart';
import 'database_helper_atendimentos.dart';
import 'chat_screen.dart';

void main() {
  runApp(const ConversasApp());
}

class ConversasApp extends StatelessWidget {
  const ConversasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meus Atendimentos',
      theme: ThemeData.dark(),
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
  final DatabaseHelperAtendimentos _dbHelper =
      DatabaseHelperAtendimentos.instance;

  List<Atendimento> _atendimentos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarAtendimentos();
  }

  Future<void> _carregarAtendimentos() async {
    final lista = await _dbHelper.getAllAtendimentos();
    if (!mounted) return;
    setState(() {
      _atendimentos = lista;
      _carregando = false;
    });
  }

  /// Gera o próximo número de atendimento no formato "#00X".
  String _proximoNumero() {
    final proximo = _atendimentos.length + 1;
    return "#${proximo.toString().padLeft(3, '0')}";
  }

  /// Abre um diálogo simples para abrir um novo atendimento.
  Future<void> _abrirNovoAtendimento() async {
    final assuntoController = TextEditingController();

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1A1A1A),
          title: const Text(
            'Novo atendimento',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: TextField(
            controller: assuntoController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Qual o assunto?',
              labelStyle: TextStyle(color: Colors.white70),
              enabledBorder: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                if (assuntoController.text.trim().isEmpty) return;
                Navigator.pop(context, true);
              },
              child: const Text('ABRIR'),
            ),
          ],
        );
      },
    );

    if (confirmou == true) {
      final atendimento = Atendimento(
        numero: _proximoNumero(),
        assunto: assuntoController.text.trim(),
        status: 'Aberta',
        dataAbertura: DateTime.now().toIso8601String(),
      );

      await _dbHelper.insertAtendimento(atendimento);
      await _carregarAtendimentos();
    }
  }

  Future<void> _excluirAtendimento(int id) async {
    await _dbHelper.deleteMensagensDoAtendimento(id);
    await _dbHelper.deleteAtendimento(id);
    await _carregarAtendimentos();
  }

  Color _corDoStatus(String status) {
    switch (status) {
      case 'Aberta':
        return Colors.green;
      case 'Em andamento':
        return Colors.orange;
      case 'Encerrada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "MEUS ATENDIMENTOS",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: _carregando
          ? const Center(
        child: CircularProgressIndicator(color: Colors.white),
      )
          : _atendimentos.isEmpty
          ? const Center(
        child: Text(
          "Você ainda não abriu nenhum atendimento.",
          style: TextStyle(color: Colors.white54),
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(15),
        children: _atendimentos
            .map((atendimento) => atendimentoCard(context, atendimento))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: _abrirNovoAtendimento,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget atendimentoCard(BuildContext context, Atendimento atendimento) {
    final cor = _corDoStatus(atendimento.status);

    return Card(
      color: const Color(0xff1A1A1A),
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.chat, color: Colors.black),
        ),
        title: Text(
          "Atendimento ${atendimento.numero}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          atendimento.assunto,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: cor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                atendimento.status,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: () => _excluirAtendimento(atendimento.id!),
              icon: const Icon(Icons.delete_outline, color: Colors.white38),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(atendimento: atendimento),
            ),
          ).then((_) => _carregarAtendimentos());
        },
      ),
    );
  }
}