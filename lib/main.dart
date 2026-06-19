import 'package:flutter/material.dart';

void main() {
  runApp(const VascoPlayApp());
}

class VascoPlayApp extends StatelessWidget {
  const VascoPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vasco Play',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const VascoPlayScreen(),
    );
  }
}

class VascoPlayScreen extends StatefulWidget {
  const VascoPlayScreen({super.key});

  @override
  State<VascoPlayScreen> createState() => _VascoPlayScreenState();
}

class _VascoPlayScreenState extends State<VascoPlayScreen> {
  int _selectedNavIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(label: 'História'),
    _NavItem(label: 'Jogos'),
    _NavItem(label: 'Sócio Gigante'),
    _NavItem(label: 'Notícias'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _VascoTopBar(
            navItems: _navItems,
            selectedIndex: _selectedNavIndex,
            onNavTap: (index) => setState(() => _selectedNavIndex = index),
          ),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedNavIndex) {
      case 0:
        return const HistoriaMenu();
      case 1:
        return const JogosMenu();
      case 2:
        return const SocioMenu();
      case 3:
        return const NoticiasMenu();
      default:
        return const SizedBox();
    }
  }
}

class _NavItem {
  final String label;
  const _NavItem({required this.label});
}

class _VascoTopBar extends StatelessWidget {
  final List<_NavItem> navItems;
  final int selectedIndex;
  final ValueChanged<int> onNavTap;

  const _VascoTopBar({
    required this.navItems,
    required this.selectedIndex,
    required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const _VascoLogo(),
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(navItems.length, (i) {
                final isSelected = selectedIndex == i;

                return GestureDetector(
                  onTap: () => onNavTap(i),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                      navItems[i].label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),

            const Divider(color: Colors.white12),
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
      errorBuilder: (_, __, ___) =>
      const Icon(Icons.image_not_supported, color: Colors.white),
    );
  }
}

class _MenuBase extends StatelessWidget {
  final String title;
  final List<String> itens;

  const _MenuBase({required this.title, required this.itens});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              '$title  V',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: itens.length,
            itemBuilder: (context, index) {
              final isDark = index % 2 == 0;

              return Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                color: isDark ? Colors.grey[400] : Colors.grey[300],
                child: Center(
                  child: Text(
                    itens[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class HistoriaMenu extends StatelessWidget {
  const HistoriaMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuBase(
      title: 'HISTÓRIA',
      itens: [
        'LINHA DO TEMPO',
        'TÍTULOS',
        'TIMES ICÔNICOS',
        'ATLETAS MARCANTES',
        'CAMISAS NEGRAS',
        'SÃO JANUÁRIO',
        'HINOS E SÍMBOLOS',
      ],
    );
  }
}

class JogosMenu extends StatelessWidget {
  const JogosMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuBase(
      title: 'JOGOS',
      itens: [
        'PROFISSIONAL MASCULINO',
        'DIREÇÃO E COMISSÃO TÉCNICA',
        'ELENCO',
        'CALENDÁRIO',
        'PROFISSIONAL FEMININO',
        'ELENCO',
        'BASE',
      ],
    );
  }
}

class NoticiasMenu extends StatelessWidget {
  const NoticiasMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuBase(
      title: 'NOTÍCIAS',
      itens: [
        'GERAL',
        'FUTEBOL PROFISSIONAL',
        'FUTEBOL FEMININO',
        'FUTEBOL BASE',
        'TRANSPARÊNCIA',
        'IMPRENSA',
        'REVISTA VASCO',
      ],
    );
  }
}

class SocioMenu extends StatelessWidget {
  const SocioMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return _MenuBase(
      title: 'SÓCIO GIGANTE',
      itens: [
        'TOUR DA COLINA',
        'INGRESSOS',
        'PLANOS',
        'FAN TOKEN DO VASCO',
        'CARTÃO PRESENTE',
        'ESPAÇO EXPERIÊNCIA',
        'OUVIDORIA',
      ],
    );
  }
}
//commit