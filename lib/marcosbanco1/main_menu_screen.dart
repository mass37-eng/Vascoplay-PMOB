import 'package:flutter/material.dart';

import 'elenco_screen.dart';
import '../keyssonpreto1/camarote_screen.dart';
import '../keyssonpreto1/direcao_comissao_screen.dart';
import '../keyssonpreto1/redes_sociais_screen.dart';
import '../lucaspreto1/cartaopresente.dart';
import '../gustavopardo1/compras.dart';
import '../mateusbranco1/conversas.dart';
import '../telas-iniciais1/Perfil.dart';
import '../telas-iniciais1/Planos.dart';
import '../telas-iniciais1/ValePresente.dart';
import '../telas-iniciais1/ingrecos.dart';
import '../telas-iniciais1/ouvidoria.dart';


class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  static final List<_MenuEntry> _itens = [
    _MenuEntry(
      titulo: 'Elenco',
      subtitulo: 'Jogadores do time profissional',
      icone: Icons.groups,
      builder: (_) => const ElencoScreen(),
    ),
    _MenuEntry(
      titulo: 'Direção e Comissão Técnica',
      subtitulo: 'Quem comanda o clube dentro e fora de campo',
      icone: Icons.badge,
      builder: (_) => const DirecaoComissaoScreen(),
    ),
    _MenuEntry(
      titulo: 'Camarotes',
      subtitulo: 'Reserva de camarotes em São Januário',
      icone: Icons.event_seat,
      builder: (_) => const CamarotesScreen(),
    ),
    _MenuEntry(
      titulo: 'Ingressos',
      subtitulo: 'Compra de ingressos para os jogos',
      icone: Icons.confirmation_number,
      builder: (_) => const IngressosScreen(),
    ),
    _MenuEntry(
      titulo: 'Planos Sócio Gigante',
      subtitulo: 'Conheça e assine um plano de sócio',
      icone: Icons.card_membership,
      builder: (_) => const PlanosScreen(),
    ),
    _MenuEntry(
      titulo: 'Assinar Plano',
      subtitulo: 'Finalize a contratação do seu plano',
      icone: Icons.shopping_cart,
      builder: (_) => const ComprarPlanoScreen(),
    ),
    _MenuEntry(
      titulo: 'Cartão Presente',
      subtitulo: 'Compre um cartão presente Vasco Play',
      icone: Icons.card_giftcard,
      builder: (_) => const ComprarCartaoPresenteScreen(),
    ),
    _MenuEntry(
      titulo: 'Vale Presente',
      subtitulo: 'Envie um vale presente para outro torcedor',
      icone: Icons.redeem,
      builder: (_) => const GiftCardScreen(),
    ),
    _MenuEntry(
      titulo: 'Redes Sociais',
      subtitulo: 'Acompanhe o Vasco nas redes',
      icone: Icons.share,
      builder: (_) => const RedesSociaisScreen(),
    ),
    _MenuEntry(
      titulo: 'Ouvidoria',
      subtitulo: 'Fale com o clube, envie dúvidas e sugestões',
      icone: Icons.support_agent,
      builder: (_) => const OuvidoriaScreen(),
    ),
    _MenuEntry(
      titulo: 'Atendimento',
      subtitulo: 'Converse com o suporte do Vasco Play',
      icone: Icons.chat_bubble,
      builder: (_) => const ConversasScreen(),
    ),
    _MenuEntry(
      titulo: 'Perfil',
      subtitulo: 'Seus dados de torcedor',
      icone: Icons.person,
      builder: (_) => const PerfilScreen(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _itens.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = _itens[index];
                  return _MenuTile(
                    entry: item,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: item.builder),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 40,
            color: const Color(0xFFE30613),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'VASCO PLAY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuEntry {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final WidgetBuilder builder;

  const _MenuEntry({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.builder,
  });
}

class _MenuTile extends StatelessWidget {
  final _MenuEntry entry;
  final VoidCallback onTap;

  const _MenuTile({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1A1A),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE30613),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(entry.icone, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.titulo,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.subtitulo,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}
