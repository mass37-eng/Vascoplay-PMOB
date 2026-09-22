import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


class EmailService {

  static const String _remetenteEmail = 'vascoplay67@gmail.com';
  static const String _remetenteSenha = 'ayaykjvngtekyiwq';
  static const String _remetenteNome = 'Vasco Play';

  /// Envia um e-mail de confirmação de login para [destinatario].
  /// Retorna true se enviou se der bom, false caso de merda.
  static Future<bool> enviarConfirmacaoLogin(String destinatario) async {
    final smtpServer = gmail(_remetenteEmail, _remetenteSenha);

    final message = Message()
      ..from = Address(_remetenteEmail, _remetenteNome)
      ..recipients.add(destinatario)
      ..subject = 'Login realizado - Vasco Play'
      ..text = 'Olá!\n\nDetectamos um novo login na sua conta do Vasco Play.\n\n'
          'Se foi você, pode ignorar este e-mail.'
      ..html = '''
        <h2>Login realizado com sucesso ✅</h2>
        <p>Detectamos um novo login na sua conta do <b>Vasco Play</b>.</p>
        <p>Se foi você, pode ignorar este e-mail.</p>
      ''';

    try {
      final sendReport = await send(message, smtpServer);
      // ignore: avoid_print
      print('E-mail enviado: $sendReport');
      return true;
    } on MailerException catch (e) {
      // ignore: avoid_print
      print('E-mail não enviado.');
      for (var p in e.problems) {
        // ignore: avoid_print
        print('Problema: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}
