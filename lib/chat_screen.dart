import 'package:flutter/material.dart';
import 'database_helper_atendimentos.dart';

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
  final ScrollController _scrollController = ScrollController();

  List<Mensagem> _mensagens = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarMensagens();
  }

  Future<void> _carregarMensagens() async {
    final lista =
    await _dbHelper.getMensagensDoAtendimento(widget.atendimento.id!);
    if (!mounted) return;
    setState(() {
      _mensagens = lista;
      _carregando = false;
    });
    _irParaFinal();
  }

  void _irParaFinal() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
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

    if (widget.atendimento.status == 'Aberta') {
      await _dbHelper.updateStatus(widget.atendimento.id!, 'Em andamento');
    }
  }

  String _formatarHora(String iso) {
    final data = DateTime.tryParse(iso);
    if (data == null) return '';
    return '${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.chat, color: Colors.black, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Atendimento ${widget.atendimento.numero}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    widget.atendimento.assunto,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _carregando
                ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
                : _mensagens.isEmpty
                ? const Center(
              child: Text(
                "Envie uma mensagem para iniciar a conversa.",
                style: TextStyle(color: Colors.white38),
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(15),
              itemCount: _mensagens.length,
              itemBuilder: (context, index) {
                final mensagem = _mensagens[index];
                return _bolhaMensagem(mensagem);
              },
            ),
          ),


          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xff1A1A1A),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _mensagemController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'digite uma mensagem',
                          hintStyle: TextStyle(color: Colors.white38),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _enviarMensagem(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.black, size: 18),
                      onPressed: _enviarMensagem,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bolhaMensagem(Mensagem mensagem) {
    final doUsuario = mensagem.doUsuario;

    return Align(
      alignment: doUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: doUsuario ? Colors.white : const Color(0xff1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              mensagem.texto,
              style: TextStyle(
                color: doUsuario ? Colors.black : Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatarHora(mensagem.dataEnvio),
              style: TextStyle(
                color: doUsuario ? Colors.black54 : Colors.white38,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
