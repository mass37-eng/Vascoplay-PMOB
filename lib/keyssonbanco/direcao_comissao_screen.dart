import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper_direcao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const VascoApp());
}

class VascoApp extends StatelessWidget {
  const VascoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vasco Play',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const DirecaoComissaoScreen(),
    );
  }
}

class DirecaoComissaoScreen extends StatefulWidget {
  const DirecaoComissaoScreen({super.key});

  @override
  State<DirecaoComissaoScreen> createState() => _DirecaoComissaoScreenState();
}

class _DirecaoComissaoScreenState extends State<DirecaoComissaoScreen> {
  final DatabaseHelperDirecao _dbHelper = DatabaseHelperDirecao.instance;

  List<StaffMember> _membros = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarMembros();
  }

  Future<void> _carregarMembros() async {
    try {
      final membros = await _dbHelper.getAllStaff();
      if (mounted) {
        setState(() {
          _membros = membros;
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
    if (_currentIndex <= 0) return;
    setState(() {
      _currentIndex--;
    });
  }

  void _proximo() {
    if (_currentIndex >= _membros.length - 1) return;
    setState(() {
      _currentIndex++;
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
                  Image.asset(
                    'assets/direcao/logo_vasco.png',
                    width: 48,
                    height: 48,
                    errorBuilder: (_, __, ___) =>
                    const Icon(Icons.shield, color: Colors.white, size: 40),
                  ),
                  const Expanded(
                    child: Column(
                      children: [
                        Text(
                          'DIREÇÃO E',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          'COMISSÃO TÉCNICA',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.account_circle_outlined,
                      color: Colors.grey, size: 36),
                ],
              ),
            ),
            const Divider(color: Color(0xFF333333), height: 1),
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
                          _carregarMembros();
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                ),
              )
                  : _membros.isEmpty
                  ? const Center(
                child: Text(
                  'Nenhum membro encontrado.',
                  style: TextStyle(
                      color: Colors.white54, fontSize: 18),
                ),
              )
                  : _buildCard(_membros[_currentIndex]),
            ),
            Container(
              color: Colors.black,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 10,
                bottom: bottomInset > 0 ? bottomInset : 14,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _anterior,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: _currentIndex > 0 ? Colors.white : Colors.grey,
                      size: 32,
                    ),
                  ),
                  GestureDetector(
                    onTap: _proximo,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: _currentIndex < _membros.length - 1
                          ? Colors.white
                          : Colors.grey,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(StaffMember membro) {
    return Container(
      color: const Color(0xFF1C1C1C),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            membro.fotoAsset,
            height: 320,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.person,
              size: 160,
              color: Colors.white54,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            membro.nome,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            membro.cargo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${membro.idade} anos',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}