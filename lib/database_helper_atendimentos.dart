import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Atendimento {
  final int? id;
  final String numero; // ex: "#001"
  final String assunto;
  final String status; // "Aberta", "Em andamento" ou "Encerrada"
  final String dataAbertura; // ISO8601

  Atendimento({
    this.id,
    required this.numero,
    required this.assunto,
    required this.status,
    required this.dataAbertura,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'numero': numero,
      'assunto': assunto,
      'status': status,
      'data_abertura': dataAbertura,
    };
  }

  factory Atendimento.fromMap(Map<String, dynamic> map) {
    return Atendimento(
      id: map['id'],
      numero: map['numero'],
      assunto: map['assunto'],
      status: map['status'],
      dataAbertura: map['data_abertura'],
    );
  }
}


class Mensagem {
  final int? id;
  final int atendimentoId;
  final String texto;
  final bool doUsuario; // true = enviada pelo usuário, false = pelo suporte
  final String dataEnvio; // ISO8601

  Mensagem({
    this.id,
    required this.atendimentoId,
    required this.texto,
    required this.doUsuario,
    required this.dataEnvio,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'atendimento_id': atendimentoId,
      'texto': texto,
      'do_usuario': doUsuario ? 1 : 0,
      'data_envio': dataEnvio,
    };
  }

  factory Mensagem.fromMap(Map<String, dynamic> map) {
    return Mensagem(
      id: map['id'],
      atendimentoId: map['atendimento_id'],
      texto: map['texto'],
      doUsuario: map['do_usuario'] == 1,
      dataEnvio: map['data_envio'],
    );
  }
}

class DatabaseHelperAtendimentos {
  static final DatabaseHelperAtendimentos instance =
  DatabaseHelperAtendimentos._internal();
  static Database? _database;

  DatabaseHelperAtendimentos._internal();

  factory DatabaseHelperAtendimentos() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vasco_atendimentos.db');

    // Esse banco não é apagado ao iniciar, para manter o histórico
    // de atendimentos entre sessões.
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE atendimentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero TEXT NOT NULL,
        assunto TEXT NOT NULL,
        status TEXT NOT NULL,
        data_abertura TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE mensagens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        atendimento_id INTEGER NOT NULL,
        texto TEXT NOT NULL,
        do_usuario INTEGER NOT NULL,
        data_envio TEXT NOT NULL,
        FOREIGN KEY (atendimento_id) REFERENCES atendimentos (id)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS mensagens (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          atendimento_id INTEGER NOT NULL,
          texto TEXT NOT NULL,
          do_usuario INTEGER NOT NULL,
          data_envio TEXT NOT NULL,
          FOREIGN KEY (atendimento_id) REFERENCES atendimentos (id)
        )
      ''');
    }
  }

  Future<int> insertAtendimento(Atendimento atendimento) async {
    final db = await database;
    return await db.insert('atendimentos', atendimento.toMap());
  }

  Future<List<Atendimento>> getAllAtendimentos() async {
    final db = await database;
    final maps = await db.query('atendimentos', orderBy: 'id DESC');
    return maps.map((m) => Atendimento.fromMap(m)).toList();
  }

  Future<int> updateStatus(int id, String novoStatus) async {
    final db = await database;
    return await db.update(
      'atendimentos',
      {'status': novoStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAtendimento(int id) async {
    final db = await database;
    return await db.delete('atendimentos', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertMensagem(Mensagem mensagem) async {
    final db = await database;
    return await db.insert('mensagens', mensagem.toMap());
  }

  Future<List<Mensagem>> getMensagensDoAtendimento(int atendimentoId) async {
    final db = await database;
    final maps = await db.query(
      'mensagens',
      where: 'atendimento_id = ?',
      whereArgs: [atendimentoId],
      orderBy: 'id ASC',
    );
    return maps.map((m) => Mensagem.fromMap(m)).toList();
  }

  Future<int> deleteMensagensDoAtendimento(int atendimentoId) async {
    final db = await database;
    return await db.delete(
      'mensagens',
      where: 'atendimento_id = ?',
      whereArgs: [atendimentoId],
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
