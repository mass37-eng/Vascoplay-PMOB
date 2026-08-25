import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
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
      home: const ElencoScreen(),
    );
  }
}

class ElencoScreen extends StatefulWidget {
  const ElencoScreen({super.key});

  @override
  State<ElencoScreen> createState() => _ElencoScreenState();
}

class _ElencoScreenState extends State<ElencoScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Jogador> _jogadores = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarJogadores();
  }

  Future<void> _carregarJogadores() async {
    try {
      final jogadores = await _dbHelper.getAllJogadores();
      if (mounted) {
        setState(() {
          _jogadores = jogadores;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _erro = 'Erro ao carregar: $e';
          _isLoading = false;
        });
      }
    }
  }

  void _anterior() {
    if (_jogadores.isEmpty) return;
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _jogadores.length) % _jogadores.length;
    });
  }

  void _proximo() {
    if (_jogadores.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _jogadores.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [

            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const VascoLogo(),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'ELENCO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                        ),
                      ),
                    ),
                  ),
                  const Icon(Icons.person, color: Colors.white, size: 28),
                ],
              ),
            ),


            Expanded(
              child: _isLoading
                  ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
                  : _erro != null

                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.redAccent, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        _erro!,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _erro = null;
                          });
                          _carregarJogadores();
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
                  : _jogadores.isEmpty
                  ? const Center(
                child: Text(
                  'Nenhum jogador encontrado.',
                  style: TextStyle(
                      color: Colors.white54, fontSize: 18),
                ),
              )
                  : _buildCard(_jogadores[_currentIndex]),
            ),


            Container(
              color: Colors.black,
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 10,
                bottom: bottomInset > 0 ? bottomInset : 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _anterior,
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white, size: 26),
                  ),
                  Text(
                    _jogadores.isEmpty
                        ? ''
                        : '${_currentIndex + 1} / ${_jogadores.length}',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: _proximo,
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Jogador jogador) {
    return Container(
      color: const Color(0xFF2A2A2A),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              jogador.fotoAsset,
              height: 260,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.person,
                size: 160,
                color: Colors.white54,
              ),
            ),
          ),
          const SizedBox(height: 28),


          Text(
            jogador.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 24),


          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoColuna(
                  icone: Icons.cake_outlined,
                  valor: '${jogador.idade}',
                  label: 'ANOS',
                ),
                _divisor(),
                _infoColunaBandeira(jogador.bandeira),
                _divisor(),
                _infoColuna(
                  icone: Icons.sports_soccer,
                  valor: jogador.posicao,
                  label: 'POSIÇÃO',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoColuna({
    required IconData icone,
    required String valor,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icone, color: Colors.white54, size: 20),
        const SizedBox(height: 6),
        Text(valor,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                color: Colors.white38, fontSize: 11, letterSpacing: 1)),
      ],
    );
  }

  Widget _infoColunaBandeira(String bandeira) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.flag_outlined, color: Colors.white54, size: 20),
        const SizedBox(height: 6),
        Text(bandeira, style: const TextStyle(fontSize: 26)),
        const SizedBox(height: 2),
        const Text('PAÍS',
            style: TextStyle(
                color: Colors.white38, fontSize: 11, letterSpacing: 1)),
      ],
    );
  }

  Widget _divisor() {
    return Container(height: 48, width: 1, color: Colors.white12);
  }
}

class VascoLogo extends StatelessWidget {
  const VascoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/jogadores/logo_vasco.png',
      width: 48,
      height: 48,
      errorBuilder: (_, __, ___) =>
      const Icon(Icons.image_not_supported, color: Colors.white),
    );
  }
}
