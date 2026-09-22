import 'package:flutter/material.dart';
import 'database_helper_compras.dart';
import 'apis_screen.dart';

void main() => runApp(const ComprarPlanoApp());

const planos = [
  {'titulo': 'NORTE A SUL', 'preco': 32.00},
  {'titulo': 'GIGANTE ★★★★★', 'preco': 225.00},
];

const corFundo = Color(0xFF1C1C1C);
const corDestaque = Color(0xFFF5A623);

class ComprarPlanoApp extends StatelessWidget {
  const ComprarPlanoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const ComprarPlanoScreen(),
    );
  }
}

class ComprarPlanoScreen extends StatefulWidget {
  const ComprarPlanoScreen({super.key});

  @override
  State<ComprarPlanoScreen> createState() => _ComprarPlanoScreenState();
}

class _ComprarPlanoScreenState extends State<ComprarPlanoScreen> {
  final _dbHelper = DatabaseHelperCompras();
  final _nomeController = TextEditingController();

  int _planoSelecionado = 0;
  String _formaPagamento = 'Pix';
  List<Compra> _compras = [];

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final compras = await _dbHelper.getAllCompras();
    setState(() => _compras = compras);
  }

  Future<void> _comprar() async {
    if (_nomeController.text.trim().isEmpty) {
      return _msg('Informe seu nome para continuar.');
    }

    final plano = planos[_planoSelecionado];
    await _dbHelper.insertCompra(Compra(
      plano: plano['titulo'] as String,
      preco: plano['preco'] as double,
      nomeComprador: _nomeController.text.trim(),
      formaPagamento: _formaPagamento,
      dataCompra: DateTime.now().toIso8601String(),
    ));

    await _carregar();
    _msg('Compra de "${plano['titulo']}" registrada com sucesso!');
  }

  void _msg(String texto) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));

  @override
  Widget build(BuildContext context) {
    final preco = planos[_planoSelecionado]['preco'] as double;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('COMPRAR PLANO', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.cloud_outlined, color: Colors.white70),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ApisScreen())),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _planosRow(),
            const SizedBox(height: 16),
            TextField(
              controller: _nomeController,
              style: const TextStyle(color: Colors.white),
              decoration: _decoracao('Digite seu nome'),
            ),
            const SizedBox(height: 16),
            _dropdownPagamento(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: corDestaque, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _comprar,
                child: Text('COMPRAR • R\$ ${preco.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Minhas compras', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (_compras.isEmpty)
              const Text('Você ainda não comprou nenhum plano.', style: TextStyle(color: Colors.white38, fontSize: 13))
            else
              ..._compras.map(_itemCompra),
          ],
        ),
      ),
    );
  }

  Widget _planosRow() {
    return Row(
      children: List.generate(planos.length, (i) {
        final on = i == _planoSelecionado;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _planoSelecionado = i),
            child: Container(
              margin: EdgeInsets.only(right: i == 0 ? 8 : 0),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(color: on ? corDestaque : corFundo, borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  Text(planos[i]['titulo'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, color: on ? Colors.black : Colors.white)),
                  Text('R\$ ${(planos[i]['preco'] as double).toStringAsFixed(2)}',
                      style: TextStyle(color: on ? Colors.black87 : Colors.white60)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _dropdownPagamento() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: corFundo, borderRadius: BorderRadius.circular(8)),
      child: DropdownButton<String>(
        value: _formaPagamento,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: corFundo,
        style: const TextStyle(color: Colors.white),
        items: const ['Pix', 'Cartão de Crédito', 'Boleto']
            .map((o) => DropdownMenuItem(value: o, child: Text(o)))
            .toList(),
        onChanged: (v) => setState(() => _formaPagamento = v ?? _formaPagamento),
      ),
    );
  }

  Widget _itemCompra(Compra c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: corFundo, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(c.plano, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text('R\$ ${c.preco.toStringAsFixed(2)} • ${c.formaPagamento}',
                    style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white38),
            onPressed: () async {
              await _dbHelper.deleteCompra(c.id!);
              _carregar();
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _decoracao(String dica) => InputDecoration(
    hintText: dica,
    hintStyle: const TextStyle(color: Colors.white38),
    filled: true,
    fillColor: corFundo,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}