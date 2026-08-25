import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper_redes.dart';

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
        scaffoldBackgroundColor: const Color(0xFF2A2A2A),
      ),
      home: const RedesSociaisScreen(),
    );
  }
}

class RedesSociaisScreen extends StatefulWidget {
  const RedesSociaisScreen({super.key});

  @override
  State<RedesSociaisScreen> createState() => _RedesSociaisScreenState();
}

class _RedesSociaisScreenState extends State<RedesSociaisScreen> {
  TextEditingController instagramController = TextEditingController();
  TextEditingController xController = TextEditingController();
  TextEditingController tiktokController = TextEditingController();
  TextEditingController facebookController = TextEditingController();

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarLinks();
  }

  Future<void> carregarLinks() async {
    RedesSociais redes = await RedesDao.buscar();
    setState(() {
      instagramController.text = redes.instagram;
      xController.text = redes.x;
      tiktokController.text = redes.tiktok;
      facebookController.text = redes.facebook;
      carregando = false;
    });
  }

  Future<void> salvar() async {
    RedesSociais redes = RedesSociais(
      id: 1,
      instagram: instagramController.text.trim(),
      x: xController.text.trim(),
      tiktok: tiktokController.text.trim(),
      facebook: facebookController.text.trim(),
    );
    await RedesDao.salvar(redes);
  }

  Future<void> limparTudo() async {
    await RedesDao.limpar();
    setState(() {
      instagramController.clear();
      xController.clear();
      tiktokController.clear();
      facebookController.clear();
    });
  }

  @override
  void dispose() {
    instagramController.dispose();
    xController.dispose();
    tiktokController.dispose();
    facebookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A2A),
      body: SafeArea(
        child: Column(
          children: [
            cabecalho(),
            const Divider(height: 1, color: Color(0xFF444444)),
            Expanded(
              child: carregando
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ADICIONAR LINKS DOS PERFIS',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1),
                    ),
                    const SizedBox(height: 24),
                    linhaRede(iconeAsset: 'assets/redes/instagram.png', controller: instagramController, hint: 'https://www.instagram.com/...'),
                    const SizedBox(height: 20),
                    linhaRede(iconeAsset: 'assets/redes/x.png', controller: xController, hint: 'https://x.com/...'),
                    const SizedBox(height: 20),
                    linhaRede(iconeAsset: 'assets/redes/tiktok.png', controller: tiktokController, hint: 'https://www.tiktok.com/@...'),
                    const SizedBox(height: 20),
                    linhaRede(iconeAsset: 'assets/redes/facebook.png', controller: facebookController, hint: 'https://www.facebook.com/...'),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: salvar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE02020),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'SALVAR ALTERAÇÕES',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: SizedBox(
                        width: 240,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: limparTudo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE02020),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'LIMPAR TUDO',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    linhaRede(
                      iconeAsset: 'assets/redes/link.png',
                      controller: TextEditingController(text: 'https://www.vascoplay.com/...'),
                      hint: '',
                      somenteLeitu: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cabecalho() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Image.asset(
            'assets/direcao/logo_vasco.png',
            width: 48,
            height: 48,
            errorBuilder: (context, erro, stack) {
              return const Icon(Icons.shield, color: Colors.white, size: 40);
            },
          ),
          const Expanded(
            child: Text(
              'REDES SOCIAIS',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: 2),
            ),
          ),
          const Icon(Icons.account_circle_outlined, color: Colors.grey, size: 36),
        ],
      ),
    );
  }

  Widget linhaRede({
    required String iconeAsset,
    required TextEditingController controller,
    required String hint,
    bool somenteLeitu = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 52,
          height: 52,
          child: Image.asset(
            iconeAsset,
            fit: BoxFit.contain,
            errorBuilder: (context, erro, stack) {
              return const Icon(Icons.image_not_supported, color: Colors.white54, size: 36);
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            readOnly: somenteLeitu,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black45, fontSize: 13, fontWeight: FontWeight.w600),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
