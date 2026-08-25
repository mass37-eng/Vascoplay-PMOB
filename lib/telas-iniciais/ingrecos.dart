import 'package:flutter/material.dart';

void main() {
  runApp(const VascoIngressosApp());
}

class VascoIngressosApp extends StatelessWidget {
  const VascoIngressosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vasco Play',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const IngressosScreen(),
    );
  }
}

class IngressosScreen extends StatelessWidget {
  const IngressosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final itens = [
      'ÁREA DE SÓCIOS',
      'TORCIDA VISITANTE',
      'ÁREA DE NÃO-SÓCIOS',
      'CAMAROTES',
      'IMPRENSA',
      'IMPRENSA',
      'TRIBUNA DE HONRA',
    ];

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
                        'VASCO PLAY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.person, color: Colors.white),
                ],
              ),
            ),
          ),

          // TÍTULO
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: const Center(
              child: Text(
                'INGRESSOS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  decoration: TextDecoration.underline,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          // LISTA
          Expanded(
            child: ListView.builder(
              itemCount: itens.length,
              itemBuilder: (context, index) {
                final isDark = index % 2 == 0;

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  color: isDark
                      ? const Color(0xFFBDBDBD)
                      : const Color(0xFFD6D6D6),
                  child: Center(
                    child: Text(
                      itens[index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // RODAPÉ
          Container(
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              children: [
                const VascoLogo(),
                const Expanded(
                  child: Center(
                    child: Text(
                      'VASCO PLAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VascoLogo extends StatelessWidget {
  const VascoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://logodownload.org/wp-content/uploads/2016/09/vasco-logo-escudo-1.png',
      width: 52,
      height: 52,
      errorBuilder: (_, __, ___) =>
      const Icon(Icons.image_not_supported, color: Colors.white),
    );
  }
}
//commit