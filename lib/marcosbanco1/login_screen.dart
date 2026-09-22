import 'package:flutter/material.dart';

import 'main_menu_screen.dart';
import 'email_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _enviandoEmail = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _continuar() async {
    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    debugPrint('Usuário: $usuario | Senha: $senha');

    if (usuario.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um e-mail válido.')),
      );
      return;
    }

    setState(() => _enviandoEmail = true);

    // Envia o e-mail de confirmação de login.

    final enviado = await EmailService.enviarConfirmacaoLogin(usuario);

    if (!mounted) return;
    setState(() => _enviandoEmail = false);

    if (!enviado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login feito, mas não consegui enviar o e-mail de confirmação.'),
        ),
      );
    }

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainMenuScreen()),
    );
  }

  void _novoUsuario() {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Escudo do Vasco
                    Image.asset(
                      'assets/jogadores/logo_vasco.png',
                      width: 48,
                      height: 48,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Placa VASCO PLAY
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

              // fundo branco com o formulário
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

                    // Senha e botão Continuar
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _buildCampoSenha()),
                        const SizedBox(width: 12),
                        _buildBotaoContinuar(),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Divisor
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
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
      onPressed: _enviandoEmail ? null : _continuar,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _enviandoEmail
          ? const SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : const Text(
        'CONTINUAR',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
