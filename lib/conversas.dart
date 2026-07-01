import 'package:flutter/material.dart';
import 'database_helper_atendimentos.dart';
import 'chat_screen.dart';
 
void main() => runApp(const ConversasApp());
 
class ConversasApp extends StatelessWidget {
  const ConversasApp({super.key});
 
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meus Atendimentos',
        theme: ThemeData.dark(),
        home: const ConversasScreen(),
      );
}
 
class ConversasScreen extends StatefulWidget {
  const ConversasScreen({super.key});
 
  @override
  State<ConversasScreen> createState() => _ConversasScreenState();
}
 
class _ConversasScreenState extends State<ConversasScreen> {
  static const _corFundo = Colors.black;
  static const _corCard = Color(0xff1A1A1A);
 
  final _dbHelper = DatabaseHelperAtendimentos.instance;
 
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
 
  String _proximoNumero() =>
      "#${(_atendimentos.length + 1).toString().padLeft(3, '0')}";
 
  Future<void> _abrirNovoAtendimento() async {
    final assuntoController = TextEditingController();
 
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _corCard,
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
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _corFundo,
        appBar: AppBar(
          backgroundColor: _corFundo,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "MEUS ATENDIMENTOS",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
        body: _buildBody(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          onPressed: _abrirNovoAtendimento,
          child: const Icon(Icons.add),
        ),
      );
 
  Widget _buildBody() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_atendimentos.isEmpty) {
      return const Center(
        child: Text(
          "Você ainda não abriu nenhum atendimento.",
          style: TextStyle(color: Colors.white54),
        ),
      );
    }
    final cards = <Widget>[];
    for (final atendimento in _atendimentos) {
      cards.add(_atendimentoCard(atendimento));
    }
 
    return ListView(
      padding: const EdgeInsets.all(15),
      children: cards,
    );
  }
 
  Widget _atendimentoCard(Atendimento atendimento) {
    return Card(
      color: _corCard,
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
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: IconButton(
          onPressed: () => _excluirAtendimento(atendimento.id!),
          icon: const Icon(Icons.delete_outline, color: Colors.white38),
        ),
        onTap: () => _abrirChat(atendimento),
      ),
    );
  }
}
 
