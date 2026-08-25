import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper_camarotes.dart';

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
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const CamarotesScreen(),
    );
  }
}

class CamarotesScreen extends StatefulWidget {
  const CamarotesScreen({super.key});

  @override
  State<CamarotesScreen> createState() => _CamarotesScreenState();
}

class _CamarotesScreenState extends State<CamarotesScreen> {
  int? planoSelecionado;
  String? formaPagamento;
  List<CamaroteRegistro> listaRegistros = [];

  TextEditingController nomeController = TextEditingController();
  TextEditingController cpfController = TextEditingController();

  List<Map<String, dynamic>> planos = [
    {
      'titulo': 'BASICO',
      'preco': 'R\$ 100,00',
      'itens': [
        'ASSENTOS DE LUXO',
        'MELHOR VISTA DO CAMPO',
        'BEBIDAS E SNACKS',
        'WI-FI E BANHEIRO EXCLUSIVO',
      ],
    },
    {
      'titulo': 'INTERMEDIÁRIO',
      'preco': 'R\$ 200,00',
      'itens': [
        'TUDO DO BÁSICO',
        'BUFFET COMPLETO',
        'BAR E BEBIDAS INCLUSAS',
        'ESTACIONAMENTO RESERVADO',
      ],
    },
    {
      'titulo': 'PREMIUM',
      'preco': 'R\$ 500,00',
      'itens': [
        'TUDO DO INTERMEDIÁRIO',
        'GASTRONOMIA PREMIUM',
        'OPEN BAR',
        'ATENDIMENTO EXCLUSIVO',
        'LOCALIZAÇÃO PRIVILEGIADA',
        'EXPERIÊNCIAS VIP COM JOGADORES/CONVIDADOS',
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    carregarRegistros();
  }

  Future<void> carregarRegistros() async {
    List<CamaroteRegistro> resultado = await CamaroteDao.buscarTodos();
    setState(() {
      listaRegistros = resultado;
    });
  }

  Future<void> registrar() async {
    String nome = nomeController.text.trim();
    String cpf = cpfController.text.trim();


    Map<String, dynamic> plano = planos[planoSelecionado!];

    CamaroteRegistro novoRegistro = CamaroteRegistro(
      nome: nome,
      cpf: cpf,
      plano: plano['titulo'],
      preco: plano['preco'],
      formaPagamento: formaPagamento!,
    );

    await CamaroteDao.inserir(novoRegistro);

    nomeController.clear();
    cpfController.clear();
    setState(() {
      planoSelecionado = null;
      formaPagamento = null;
    });

    await carregarRegistros();
  }

  Future<void> deletarRegistro(int id) async {
    await CamaroteDao.deletar(id);
    await carregarRegistros();
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            cabecalho(),
            const Divider(height: 1, color: Color(0xFFCCCCCC)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    cardPlano(0, planos[0]),
                    cardPlano(1, planos[1]),
                    cardPlano(2, planos[2]),
                    const SizedBox(height: 10),
                    formulario(),
                    if (listaRegistros.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      secaoRegistros(),
                    ],
                    const SizedBox(height: 16),
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
              'CAMAROTES',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const Icon(Icons.account_circle_outlined, color: Colors.grey, size: 36),
        ],
      ),
    );
  }

  Widget cardPlano(int indice, Map<String, dynamic> plano) {
    bool selecionado = planoSelecionado == indice;
    List<String> itens = plano['itens'];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            plano['titulo'],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: itens.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      plano['preco'],
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        planoSelecionado = indice;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: selecionado ? Colors.black : Colors.white,
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: selecionado
                          ? const Icon(Icons.check, color: Colors.white, size: 22)
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget formulario() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text('NOME', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nomeController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  children: [
                    const Text('CPF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: cpfController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('FORMA DE PAGAMENTO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1)),
          const SizedBox(height: 8),
          Row(
            children: [
              botaoPagamento('PIX'),
              const SizedBox(width: 8),
              botaoPagamento('CRÉDITO'),
              const SizedBox(width: 8),
              botaoPagamento('DÉBITO'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: registrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE02020),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text(
                'REGISTRAR',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget botaoPagamento(String label) {
    bool selecionado = formaPagamento == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            formaPagamento = label;
          });
        },
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: selecionado ? Colors.white : const Color(0xFF222222),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: selecionado ? Colors.white : const Color(0xFF555555), width: 2),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selecionado ? Colors.black : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget secaoRegistros() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'REGISTROS',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        const SizedBox(height: 10),
        Column(
          children: listaRegistros.map((r) => cardRegistro(r)).toList(),
        ),
      ],
    );
  }

  Widget cardRegistro(CamaroteRegistro r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.nome, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('CPF: ${r.cpf}', style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(4)),
                      child: Text(r.plano, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(4)),
                      child: Text(r.formaPagamento, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(r.preco, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => deletarRegistro(r.id!),
                child: const Icon(Icons.delete_outline, color: Color(0xFFE02020), size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}