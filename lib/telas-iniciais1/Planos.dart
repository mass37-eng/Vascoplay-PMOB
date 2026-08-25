import 'package:flutter/material.dart';

void main() {
  runApp(const VascoPlanosApp());
}

class VascoPlanosApp extends StatelessWidget {
  const VascoPlanosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planos Vasco',
      theme: ThemeData.dark(),
      home: const PlanosScreen(),
    );
  }
}


class PlanosScreen extends StatelessWidget {
  const PlanosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // HEADER
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.black,
              child: Row(
                children: [
                  const _VascoLogo(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'PLANOS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.person, size: 28),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              children: const [
                PlanoCard(
                  titulo: "NORTE A SUL",
                  preco: "R\$ 32,00 / mês",
                  beneficios: [
                    "10% de desconto nas lojas",
                    "Experiências para fora do Rio",
                    "Até 50% desconto em ingressos",
                    "50% desconto no Tour da Colina",
                  ],
                ),
                PlanoCard(
                  titulo: "GIGANTE ★★★★★",
                  preco: "R\$ 225,00 / mês",
                  beneficios: [
                    "10% de desconto nas lojas",
                    "Até 75% desconto em ingressos",
                    "Adicionar convidados com desconto",
                    "50% desconto no Tour da Colina",
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanoCard extends StatelessWidget {
  final String titulo;
  final String preco;
  final List<String> beneficios;

  const PlanoCard({
    super.key,
    required this.titulo,
    required this.preco,
    required this.beneficios,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE5E5E5),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),

          Column(
            children: beneficios.map((b) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.orange),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        b,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            color: Colors.black,
            child: Text(
              preco,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A623),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {},
              child: const Text(
                "ASSOCIE-SE",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 LOGO MELHORADO IMPLEMENTADO
class _VascoLogo extends StatelessWidget {
  const _VascoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        'https://logodownload.org/wp-content/uploads/2016/09/vasco-logo-escudo-1.png',
        width: 52,
        height: 52,
        fit: BoxFit.contain,

        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            width: 52,
            height: 52,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },

        errorBuilder: (_, __, ___) => const SizedBox(
          width: 52,
          height: 52,
          child: Icon(Icons.image_not_supported, color: Colors.white),
        ),
      ),
    );
  }
}

//commit