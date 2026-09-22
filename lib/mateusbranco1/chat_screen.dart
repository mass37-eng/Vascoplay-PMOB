import 'package:flutter/material.dart';
import 'database_helper_atendimentos.dart';
import 'api_service.dart';

class ChatScreen extends StatefulWidget {
  final Atendimento atendimento;

  const ChatScreen({super.key, required this.atendimento});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseHelperAtendimentos _dbHelper =
      DatabaseHelperAtendimentos.instance;
  final TextEditingController _mensagemController = TextEditingController();

  List<Mensagem> _mensagens = [];
  bool _carregando = true;

  late Future<String> _futureDica;

  @override
  void initState() {
    super.initState();
    _carregarMensagens();
    _futureDica = AdviceApiService.buscarDica();
  }

  Future<void> _carregarMensagens() async {
    final lista =
    await _dbHelper.getMensagensDoAtendimento(widget.atendimento.id!);
    setState(() {
      _mensagens = lista;
      _carregando = false;
    });
  }

  Future<void> _enviarMensagem() async {
    final texto = _mensagemController.text.trim();
    if (texto.isEmpty) return;

    final mensagem = Mensagem(
      atendimentoId: widget.atendimento.id!,
      texto: texto,
      doUsuario: true,
      dataEnvio: DateTime.now().toIso8601String(),
    );

    await _dbHelper.insertMensagem(mensagem);
    _mensagemController.clear();
    await _carregarMensagens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Atendimento ${widget.atendimento.numero}'),
      ),
      body: Column(
        children: [
          _textoDica(),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final mensagem = _mensagens[index];
                return ListTile(
                  title: Text(mensagem.texto),
                  subtitle: Text(mensagem.dataEnvio),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _mensagemController,
                  decoration: const InputDecoration(
                    hintText: 'Digite uma mensagem',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _enviarMensagem,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _textoDica() {
    return FutureBuilder<String>(
      future: _futureDica,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Carregando dica...');
        }
        if (snapshot.hasError) {
          return const Text('Não foi possível carregar a dica.');
        }
        return Text(snapshot.data!);
      },
    );
  }
}
