import 'package:flutter/material.dart';

import 'main_menu_screen.dart';

/// Tela de login do Vasco Play — versão simplificada:
/// fundo preto liso, logo do Vasco, card branco com usuário/senha
/// e botão "Continuar". Sem Stack/faixas decorativas, para evitar
/// problemas de layout.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _senhaVisivel = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _continuar() {
    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    // TODO: substituir pela lógica real de autenticação
    debugPrint('Usuário: $usuario | Senha: $senha');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
    );
  }

  void _novoUsuario() {
    // TODO: navegar para a tela de cadastro
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              // Logo + "Vasco Play"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    // Escudo do Vasco
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: Image.asset(
                        'assets/direcao/vasco_escudo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.shield, color: Colors.white, size: 60),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Placa "VASCO PLAY"
                    Expanded(
                      child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'VASCO PLAY',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 130),

              // Card branco com o formulário
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Usuario:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    _buildCampoUsuario(),

                    const SizedBox(height: 20),

                    const Text(
                      'Senha:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // Senha + botão Continuar lado a lado
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _buildCampoSenha()),
                        const SizedBox(width: 12),
                        _buildBotaoContinuar(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Divisor "ou utilize uma das opções abaixo"
                    Row(
                      children: const [
                        Expanded(child: Divider(color: Colors.grey)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            'ou utilize uma das opções abaixo',
                            style: TextStyle(color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey)),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Novo Usuario
                    Center(
                      child: TextButton(
                        onPressed: _novoUsuario,
                        child: const Text(
                          'Novo Usuario',
                          style: TextStyle(
                            color: Color(0xFF1A0DAB),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Política de privacidade
                    const Text.rich(
                      TextSpan(
                        style: TextStyle(color: Colors.black87, fontSize: 14),
                        children: [
                          TextSpan(text: 'Ao continuar você concorda com nossa '),
                          TextSpan(
                            text: 'política de privacidade.',
                            style: TextStyle(
                              color: Color(0xFF1A0DAB),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCampoUsuario() {
    return TextField(
      controller: _usuarioController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: 'Exemplo: AlunoIfal@gmail.com',
        filled: true,
        fillColor: const Color(0xFFB5B5B5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCampoSenha() {
    return TextField(
      controller: _senhaController,
      obscureText: !_senhaVisivel,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFB5B5B5),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: Icon(_senhaVisivel ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _senhaVisivel = !_senhaVisivel),
        ),
      ),
    );
  }

  Widget _buildBotaoContinuar() {
    return ElevatedButton(
      onPressed: _continuar,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'CONTINUAR',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
