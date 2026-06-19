import 'package:flutter/material.dart';

void main() {
  runApp(const VascoOuvidoriaApp());
}

class VascoOuvidoriaApp extends StatelessWidget {
  const VascoOuvidoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vasco Ouvidoria',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const OuvidoriaScreen(),
    );
  }
}

class OuvidoriaScreen extends StatelessWidget {
  const OuvidoriaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // TOPO
          SafeArea(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const VascoLogo(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'OUVIDORIA',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.person, size: 28),
                ],
              ),
            ),
          ),

          // CHAT
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF111111),
              ),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  ChatBubbleLeft(
                    text:
                    'Olá! Você entrou em contato com a Ouvidoria. Sua solicitação foi recebida e será analisada com atenção.',
                  ),
                  SizedBox(height: 20),
                  ChatBubbleRight(
                    text: 'gostaria de ajuda com os planos',
                  ),
                ],
              ),
            ),
          ),

          // INPUT
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.black,
            child: Row(
              children: [
                const Icon(Icons.add, size: 28),
                const SizedBox(width: 10),

                // CAMPO DE TEXTO
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'digite uma mensagem',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // BOTÃO ENVIAR
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// BOLHA ESQUERDA
class ChatBubbleLeft extends StatelessWidget {
  final String text;

  const ChatBubbleLeft({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.black),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

// BOLHA DIREITA
class ChatBubbleRight extends StatelessWidget {
  final String text;

  const ChatBubbleRight({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              text,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(width: 10),
        const CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: Colors.black),
        ),
      ],
    );
  }
}

// LOGO
class VascoLogo extends StatelessWidget {
  const VascoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://logodownload.org/wp-content/uploads/2016/09/vasco-logo-escudo-1.png',
      width: 50,
      height: 50,
      errorBuilder: (_, __, ___) =>
      const Icon(Icons.image_not_supported),
    );
  }
}
//commit