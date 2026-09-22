import 'package:flutter/material.dart';
import 'api_cotacao_service.dart';

class CotacaoScreen extends StatefulWidget {

  final double valorEmReais;

  final String? tituloCartao;

  const CotacaoScreen({
    super.key,
    this.valorEmReais = 13.98,
    this.tituloCartao,
  });

  @override
  State<CotacaoScreen> createState() => _CotacaoScreenState();
}

class _CotacaoScreenState extends State<CotacaoScreen> {
  final ApiCotacaoService _service = ApiCotacaoService();

  late Future<List<Cotacao>> _futureCotacoes;

  @override
  void initState() {
    super.initState();
    _futureCotacoes = _service.buscarCotacoes();
  }

  void _recarregar() {
    setState(() {
      _futureCotacoes = _service.buscarCotacoes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Cotacao do Cartao'),
        actions: [
          IconButton(
            onPressed: _recarregar,
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar cotacoes',
          ),
        ],
      ),
      body: Column(
        children: [
          _cabecalho(),
          Expanded(
            child: FutureBuilder<List<Cotacao>>(
              future: _futureCotacoes,
              builder: (context, snapshot) {
                // 1) Ainda carregando
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: Color(0xFFF5A623)),
                        SizedBox(height: 16),
                        Text(
                          'Consultando as cotacoes...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  );
                }

                // 2) Deu erro
                if (snapshot.hasError) {
                  return _erro(
                    'Nao foi possivel carregar as cotacoes.\n'
                    'Verifique sua conexao com a internet.',
                    snapshot.error.toString(),
                  );
                }

                // 3) Voltou vazio
                final cotacoes = snapshot.data ?? [];
                if (cotacoes.isEmpty) {
                  return _erro('Nenhuma cotacao foi retornada pela API.', null);
                }

                // 4) Sucesso
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cotacoes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _CotacaoTile(
                      cotacao: cotacoes[index],
                      valorEmReais: widget.valorEmReais,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _cabecalho() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF111111),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.tituloCartao ?? 'Cartao Presente Vasco',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'R\$ ${widget.valorEmReais.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFFF5A623),
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Valor convertido em tempo real pela AwesomeAPI',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _erro(String mensagem, String? detalhe) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, color: Colors.white38, size: 48),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            if (detalhe != null) ...[
              const SizedBox(height: 8),
              Text(
                detalhe,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white24, fontSize: 11),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5A623),
                foregroundColor: Colors.black,
              ),
              onPressed: _recarregar,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CotacaoTile extends StatelessWidget {
  final Cotacao cotacao;
  final double valorEmReais;

  const _CotacaoTile({required this.cotacao, required this.valorEmReais});

  @override
  Widget build(BuildContext context) {
    final subiu = cotacao.pctChange >= 0;
    final convertido = cotacao.converterDeReais(valorEmReais);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5A623),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  cotacao.code,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cotacao.nomeCurto,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    subiu ? Icons.arrow_upward : Icons.arrow_downward,
                    color: subiu ? Colors.greenAccent : Colors.redAccent,
                    size: 14,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${cotacao.pctChange.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: subiu ? Colors.greenAccent : Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'O cartao custa ${convertido.toStringAsFixed(2)} ${cotacao.code}',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            '1 ${cotacao.code} = R\$ ${cotacao.bid.toStringAsFixed(4)}   |   '
            'Max R\$ ${cotacao.high.toStringAsFixed(2)}   '
            'Min R\$ ${cotacao.low.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            'Atualizado em ${cotacao.createDate}',
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
