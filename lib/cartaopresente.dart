import 'package:flutter/material.dart';
import 'database_helper_cartao_presente.dart';

void main() {
  runApp(const ComprarCartaoPresenteApp());
}

class ComprarCartaoPresenteApp extends StatelessWidget {
  const ComprarCartaoPresenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cartão Presente',
      theme: ThemeData.dark(),
      home: const ComprarCartaoPresenteScreen(),
    );
  }
}


class _CartaoInfo {
  final String titulo;
  final double preco;
  final List<String> beneficios;

  const _CartaoInfo({
    required this.titulo,
    required this.preco,
    required this.beneficios,
  });
}

class ComprarCartaoPresenteScreen extends StatefulWidget {
  const ComprarCartaoPresenteScreen({super.key});

  @override
  State<ComprarCartaoPresenteScreen> createState() =>
      _ComprarCartaoPresenteScreenState();
}

class _ComprarCartaoPresenteScreenState
    extends State<ComprarCartaoPresenteScreen> {
  final DatabaseHelperCartaoPresente _dbHelper =
      DatabaseHelperCartaoPresente.instance;

  final List<_CartaoInfo> _cartoes = const [
    _CartaoInfo(
      titulo: 'Camisas Negras',
      preco: 13.98,
      beneficios: [
        '30% de desconto no ingresso',
        '10% de desconto nas lojas oficiais',
        '6ª onda na compra de ingressos',
        'Descontos na rede de parceiros',
      ],
    ),
    _CartaoInfo(
      titulo: 'Norte a Sul',
      preco: 31.98,
      beneficios: [
        '50% de desconto no ingresso',
        '10% de desconto nas lojas oficiais',
        '5ª onda na compra de ingressos',
        'Exclusivo para fora do RJ',
      ],
    ),
  ];

  int _cartaoSelecionado = 0;
  String _formaPagamento = 'Pix';
  final _nomeController = TextEditingController();

  List<CompraCartaoPresente> _compras = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final compras = await _dbHelper.getAllCompras();
    if (!mounted) return;
    setState(() => _compras = compras);
  }

  Future<void> _comprar() async {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe seu nome para continuar.')),
      );
      return;
    }

    final cartao = _cartoes[_cartaoSelecionado];
    final compra = CompraCartaoPresente(
      cartao: cartao.titulo,
      preco: cartao.preco,
      nomeComprador: _nomeController.text.trim(),
      formaPagamento: _formaPagamento,
      dataCompra: DateTime.now().toIso8601String(),
    );

    await _dbHelper.insertCompra(compra);
    await _carregarHistorico();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cartão "${cartao.titulo}" comprado com sucesso!'),
        backgroundColor: Colors.green[700],
      ),
    );
  }

  Future<void> _excluirCompra(int id) async {
    await _dbHelper.deleteCompra(id);
    await _carregarHistorico();
  }

  @override
  Widget build(BuildContext context) {
    final cartaoAtual = _cartoes[_cartaoSelecionado];

    return Scaffold(
      body: Stack(
        children: [
      
          Positioned.fill(
            child: Image.network(
              "https://vasco.com.br/wp-content/uploads/2023/05/torcida-vasco.jpg",
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: Colors.black),
            ),
          ),

   
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.45)),
          ),

          Column(
            children: [
         
              SafeArea(
                child: Container(
                  color: Colors.black,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(height: 4),
                            Divider(color: Colors.white, thickness: 2),
                          ],
                        ),
                      ),
                      const Icon(Icons.account_circle,
                          size: 38, color: Colors.white70),
                    ],
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 25),
                  children: [
                 
                    ...List.generate(_cartoes.length, (i) {
                      final selecionado = i == _cartaoSelecionado;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 28),
                        child: GestureDetector(
                          onTap: () => setState(() => _cartaoSelecionado = i),
                          child: _GiftCardPlan(
                            cartao: _cartoes[i],
                            selecionado: selecionado,
                          ),
                        ),
                      );
                    }),

               
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Comprar "${cartaoAtual.titulo}"',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('Seu nome',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _nomeController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Digite seu nome',
                              hintStyle:
                              const TextStyle(color: Colors.white38),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.08),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text('Forma de pagamento',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: DropdownButton<String>(
                              value: _formaPagamento,
                              isExpanded: true,
                              underline: const SizedBox(),
                              dropdownColor: const Color(0xFF1C1C1C),
                              style: const TextStyle(color: Colors.white),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Pix', child: Text('Pix')),
                                DropdownMenuItem(
                                    value: 'Cartão de Crédito',
                                    child: Text('Cartão de Crédito')),
                                DropdownMenuItem(
                                    value: 'Boleto', child: Text('Boleto')),
                              ],
                              onChanged: (v) => setState(
                                      () => _formaPagamento = v ?? _formaPagamento),
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF5A623),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              onPressed: _comprar,
                              child: Text(
                                'COMPRAR • R\$ ${cartaoAtual.preco.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

              
                    const Text(
                      'Meus cartões presente',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    if (_compras.isEmpty)
                      const Text(
                        'Você ainda não comprou nenhum cartão presente.',
                        style: TextStyle(color: Colors.white60, fontSize: 13),
                      )
                    else
                      ..._compras.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(c.cartao,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13)),
                                    Text(
                                      'R\$ ${c.preco.toStringAsFixed(2)} • ${c.formaPagamento}',
                                      style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => _excluirCompra(c.id!),
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.white60, size: 20),
                              ),
                            ],
                          ),
                        ),
                      )),
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


class _GiftCardPlan extends StatelessWidget {
  final _CartaoInfo cartao;
  final bool selecionado;

  const _GiftCardPlan({required this.cartao, required this.selecionado});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: selecionado ? const Color(0xFFF5A623) : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          children: [
       
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black12)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    color: Colors.black,
                    child: const Icon(Icons.card_membership,
                        color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      cartao.titulo,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (selecionado)
                    const Icon(Icons.check_circle,
                        color: Color(0xFFF5A623), size: 22),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: cartao.beneficios.map((beneficio) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("•",
                            style: TextStyle(color: Colors.black, fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            beneficio,
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 16, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

   
            Transform.translate(
              offset: const Offset(0, 15),
              child: Container(
                width: 150,
                padding: const EdgeInsets.symmetric(vertical: 14),
                color: Colors.black,
                child: Center(
                  child: Text(
                    'R\$ ${cartao.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
      width: 48,
      height: 48,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const SizedBox(
        width: 48,
        height: 48,
        child: Icon(Icons.image_not_supported, color: Colors.white),
      ),
    );
  }
}
