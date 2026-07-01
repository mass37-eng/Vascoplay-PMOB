import 'package:flutter/material.dart';
import 'database_helper_compras.dart';

void main() {
  runApp(const ComprarPlanoApp());
}

class ComprarPlanoApp extends StatelessWidget {
  const ComprarPlanoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comprar Plano',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const ComprarPlanoScreen(),
    );
  }
}

class _PlanoInfo {
  final String titulo;
  final double preco;

  const _PlanoInfo({
    required this.titulo,
    required this.preco,
  });
}

class ComprarPlanoScreen extends StatefulWidget {
  const ComprarPlanoScreen({super.key});

  @override
  State<ComprarPlanoScreen> createState() => _ComprarPlanoScreenState();
}

class _ComprarPlanoScreenState extends State<ComprarPlanoScreen> {
  final DatabaseHelperCompras _dbHelper = DatabaseHelperCompras();

  final List<_PlanoInfo> _planos = const [
    _PlanoInfo(titulo: 'NORTE A SUL', preco: 32.00),
    _PlanoInfo(titulo: 'GIGANTE ★★★★★', preco: 225.00),
  ];

  int _planoSelecionado = 0;
  String _formaPagamento = 'Pix';
  final _nomeController = TextEditingController();

  List<Compra> _compras = [];

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
        const SnackBar(
          content: Text('Informe seu nome para continuar.'),
        ),
      );
      return;
    }

    final plano = _planos[_planoSelecionado];

    final compra = Compra(
      plano: plano.titulo,
      preco: plano.preco,
      nomeComprador: _nomeController.text.trim(),
      formaPagamento: _formaPagamento,
      dataCompra: DateTime.now().toIso8601String(),
    );

    await _dbHelper.insertCompra(compra);
    await _carregarHistorico();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Compra de "${plano.titulo}" registrada com sucesso!',
        ),
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
    final planoAtual = _planos[_planoSelecionado];

    List<Widget> botoesDePlano = [];

    for (int i = 0; i < _planos.length; i++) {
      final selecionado = i == _planoSelecionado;

      botoesDePlano.add(
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _planoSelecionado = i),
            child: Container(
              margin: EdgeInsets.only(right: i == 0 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: selecionado
                    ? const Color(0xFFF5A623)
                    : const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    _planos[i].titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: selecionado ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${_planos[i].preco.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: selecionado
                          ? Colors.black87
                          : Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    List<Widget> itensDeCompras = [];

    if (_compras.isEmpty) {
      itensDeCompras.add(
        const Text(
          'Você ainda não comprou nenhum plano.',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 13,
          ),
        ),
      );
    } else {
      for (var c in _compras) {
        itensDeCompras.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          c.plano,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          'R\$ ${c.preco.toStringAsFixed(2)} • ${c.formaPagamento}',
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _excluirCompra(c.id!),
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'COMPRAR PLANO',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Escolha o plano',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Row(children: botoesDePlano),
            const SizedBox(height: 24),
            const Text(
              'Seu nome',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nomeController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Digite seu nome',
                hintStyle:
                    const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1C1C1C),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Forma de pagamento',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButton<String>(
                value: _formaPagamento,
                isExpanded: true,
                underline: const SizedBox(),
                dropdownColor: const Color(0xFF1C1C1C),
                style:
                    const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(
                    value: 'Pix',
                    child: Text('Pix'),
                  ),
                  DropdownMenuItem(
                    value: 'Cartão de Crédito',
                    child: Text('Cartão de Crédito'),
                  ),
                  DropdownMenuItem(
                    value: 'Boleto',
                    child: Text('Boleto'),
                  ),
                ],
                onChanged: (v) => setState(
                  () => _formaPagamento =
                      v ?? _formaPagamento,
                ),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFF5A623),
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                ),
                onPressed: _comprar,
                child: Text(
                  'COMPRAR • R\$ ${planoAtual.preco.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Minhas compras',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...itensDeCompras,
          ],
        ),
      ),
    );
  }
}
