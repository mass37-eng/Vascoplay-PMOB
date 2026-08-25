import 'package:flutter/material.dart';

void main() {
  runApp(const VascoGiftCardApp());
}

class VascoGiftCardApp extends StatelessWidget {
  const VascoGiftCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartão Presente',
      theme: ThemeData.dark(),
      home: const GiftCardScreen(),
    );
  }
}

class GiftCardScreen extends StatelessWidget {
  const GiftCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Positioned.fill(
            child: Image.network(
              "https://vasco.com.br/wp-content/uploads/2023/05/torcida-vasco.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// OVERLAY ESCURO
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.35),
            ),
          ),

          Column(
            children: [
              /// HEADER
              SafeArea(
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      const _VascoLogo(),
                      const SizedBox(width: 12),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CARTÃO PRESENTE",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 4),
                            Divider(
                              color: Colors.white,
                              thickness: 2,
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.account_circle,
                        size: 42,
                        color: Colors.white70,
                      ),
                    ],
                  ),
                ),
              ),

              /// LISTA DOS CARDS
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 25,
                  ),
                  children: const [
                    GiftCardPlan(
                      titulo: "Camisas Negras",
                      preco: "R\$ 13,98",
                      beneficios: [
                        "30% de desconto no ingresso",
                        "10% de desconto nas lojas oficiais",
                        "6ª onda na compra de ingressos",
                        "Descontos na rede de parceiros",
                        "Carteirinha física",
                        "50% no Tour da Colina",
                        "Resgates",
                      ],
                    ),
                    SizedBox(height: 28),
                    GiftCardPlan(
                      titulo: "Norte a Sul",
                      preco: "R\$ 31,98",
                      beneficios: [
                        "50% de desconto no ingresso",
                        "10% de desconto nas lojas oficiais",
                        "5ª onda na compra de ingressos",
                        "Rede de parceiros",
                        "Exclusivo para fora do RJ",
                        "50% no Tour da Colina",
                        "Resgates",
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GiftCardPlan extends StatelessWidget {
  final String titulo;
  final String preco;
  final List<String> beneficios;

  const GiftCardPlan({
    super.key,
    required this.titulo,
    required this.preco,
    required this.beneficios,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            /// TOPO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black12),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    color: Colors.black,
                    child: const Icon(
                      Icons.card_membership,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      titulo,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// BENEFÍCIOS
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: beneficios.map((beneficio) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "•",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            beneficio,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            /// PREÇO
            Transform.translate(
              offset: const Offset(0, 15),
              child: Container(
                width: 150,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                color: Colors.black,
                child: Center(
                  child: Text(
                    preco,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class _VascoLogo extends StatelessWidget {
  const _VascoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://logodownload.org/wp-content/uploads/2016/09/vasco-logo-escudo-1.png',
      width: 52,
      height: 52,
      fit: BoxFit.contain,
    );
  }
}
//commit