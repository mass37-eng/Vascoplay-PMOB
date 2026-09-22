import 'package:flutter/material.dart';
import 'VascoApiService.dart';
import 'VascoApiService.dart';
import 'apis_screen.dart';
import 'propriedade_api_service.dart';

class ApisScreen extends StatelessWidget {
  ApisScreen({super.key});

  final _vascoApi = VascoApiService();
  final _propriedadeApi = PropriedadeApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Consumo de APIs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('API Real (TheSportsDB)',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildApiReal(),
          const SizedBox(height: 32),
          const Text('API Fake',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildApiFake(),
        ],
      ),
    );
  }

  Widget _buildApiReal() {
    return FutureBuilder<Time>(
      future: _vascoApi.buscarTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent));
        }

        final time = snapshot.data!;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (time.escudo.isNotEmpty)
                Center(
                  child: Image.network(time.escudo, height: 100),
                ),
              const SizedBox(height: 12),
              Text(time.nome,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('Estádio: ${time.estadio}', style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 10),
              Text(
                time.descricao,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildApiFake() {
    return FutureBuilder<List<Propriedade>>(
      future: _propriedadeApi.buscarPropriedades(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent));
        }

        final propriedades = snapshot.data!;

        return Column(
          children: propriedades.map((p) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1C),
                borderRadius: BorderRadius.circular(8),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(p.urlImagem, height: 140, width: double.infinity, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.local,
                            style: const TextStyle(
                                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('${p.host} • ★ ${p.avaliacao}',
                            style: const TextStyle(color: Colors.white60, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${p.dates} • R\$ ${p.total}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}