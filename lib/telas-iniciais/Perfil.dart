import 'package:flutter/material.dart';

void main() {
  runApp(const PerfilApp());
}

class PerfilApp extends StatelessWidget {
  const PerfilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const PerfilScreen(),
    );
  }
}

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            /// 🔝 TOPO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Image.network(
                    'https://logodownload.org/wp-content/uploads/2016/09/vasco-logo-escudo-1.png',
                    width: 50,
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'VASCO PLAY',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.person),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// TÍTULO
            const Text(
              'PERFIL',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Divider(color: Colors.white24),

            const SizedBox(height: 30),

            /// 👤 USUÁRIO
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 35, color: Colors.black),
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Marcos moleke',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.logout),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// CONFIGURAÇÕES
            _item(Icons.settings, 'CONFIGURAÇÕES'),

            /// PERFIL
            _item(Icons.person, 'PERFIL'),

            const SizedBox(height: 40),

            /// REDES SOCIAIS
            const Text(
              'REDES SOCIAIS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.camera_alt, size: 40),
                SizedBox(width: 40),
                Icon(Icons.close, size: 40),
                SizedBox(width: 40),
                Icon(Icons.music_note, size: 40),
              ],
            ),

            const Spacer(),

            /// RODAPÉ
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Image.network(
                    'https://logodownload.org/wp-content/uploads/2016/09/vasco-logo-escudo-1.png',
                    width: 40,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'VASCO PLAY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  static Widget _item(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 20),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
//commit