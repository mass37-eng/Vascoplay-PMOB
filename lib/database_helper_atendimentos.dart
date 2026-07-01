import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
 
class Atendimento {
  final int? id;
  final String numero;
  final String assunto;
  final String dataAbertura;
 
  Atendimento({
    this.id,
    required this.numero,
    required this.assunto,
    required this.dataAbertura,
  });
 
  Map<String, dynamic> toMap() => {
        'id': id,
        'numero': numero,
        'assunto': assunto,
        'data_abertura': dataAbertura,
      };
 
  factory Atendimento.fromMap(Map<String, dynamic> map) => Atendimento(
        id: map['id'],
        numero: map['numero'],
        assunto: map['assunto'],
        dataAbertura: map['data_abertura'],
      );
}
 
class Mensagem {
  final int? id;
  final int atendimentoId;
  final String texto;
  final bool doUsuario;
  final String dataEnvio;
 
  Mensagem({
    this.id,
    required this.atendimentoId,
    required this.texto,
    required this.doUsuario,
    required this.dataEnvio,
  });
 
  Map<String, dynamic> toMap() => {
        'id': id,
        'atendimento_id': atendimentoId,
        'texto': texto,
        'do_usuario': doUsuario ? 1 : 0,
        'data_envio': dataEnvio,
      };
 
  factory Mensagem.fromMap(Map<String, dynamic> map) => Mensagem(
        id: map['id'],
        atendimentoId: map['atendimento_id'],
        texto: map['texto'],
        doUsuario: map['do_usuario'] == 1,
        dataEnvio: map['data_envio'],
      );
}
 
class DatabaseHelperAtendimentos {
  static final DatabaseHelperAtendimentos instance =
      DatabaseHelperAtendimentos();
 
  static Database? _database;
 
  static const _tabelaAtendimentos = '''
    CREATE TABLE atendimentos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      numero TEXT NOT NULL,
      assunto TEXT NOT NULL,
      data_abertura TEXT NOT NULL
    )
  ''';
 
  static const _tabelaMensagens = '''
    CREATE TABLE IF NOT EXISTS mensagens (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      atendimento_id INTEGER NOT NULL,
      texto TEXT NOT NULL,
      do_usuario INTEGER NOT NULL,
      data_envio TEXT NOT NULL,
      FOREIGN KEY (atendimento_id) REFERENCES atendimentos (id)
    )
  ''';
 
  Future<Database> getDatabase() async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }
 
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'vasco_atendimentos.db');
    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute(_tabelaAtendimentos);
        await db.execute(_tabelaMensagens);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) await db.execute(_tabelaMensagens);
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE atendimentos DROP COLUMN status');
        }
      },
    );
  }
 
  Future<int> insertAtendimento(Atendimento atendimento) async {
    final db = await getDatabase();
    return db.insert('atendimentos', atendimento.toMap());
  }
 
  Future<List<Atendimento>> getAllAtendimentos() async {
    final db = await getDatabase();
    final maps = await db.query('atendimentos', orderBy: 'id DESC');
 
    final lista = <Atendimento>[];
    for (final mapa in maps) {
      lista.add(Atendimento.fromMap(mapa));
    }
    return lista;
  }
 
  Future<int> deleteAtendimento(int id) async {
    final db = await getDatabase();
    return db.delete('atendimentos', where: 'id = ?', whereArgs: [id]);
  }
 
  Future<int> insertMensagem(Mensagem mensagem) async {
    final db = await getDatabase();
    return db.insert('mensagens', mensagem.toMap());
  }
 
  Future<List<Mensagem>> getMensagensDoAtendimento(int atendimentoId) async {
    final db = await getDatabase();
    final maps = await db.query(
      'mensagens',
      where: 'atendimento_id = ?',
      whereArgs: [atendimentoId],
      orderBy: 'id ASC',
    );
 
    final lista = <Mensagem>[];
    for (final mapa in maps) {
      lista.add(Mensagem.fromMap(mapa));
    }
    return lista;
  }
 
  Future<int> deleteMensagensDoAtendimento(int atendimentoId) async {
    final db = await getDatabase();
    return db.delete(
      'mensagens',
      where: 'atendimento_id = ?',
      whereArgs: [atendimentoId],
    );
  }
 
  Future<void> close() async {
    final db = await getDatabase();
    await db.close();
  }
}
 
