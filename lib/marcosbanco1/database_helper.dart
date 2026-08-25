import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Jogador {
  final int? id;
  final String nome;
  final int idade;
  final String bandeira;
  final String posicao;
  final String fotoAsset;

  Jogador({
    this.id,
    required this.nome,
    required this.idade,
    required this.bandeira,
    required this.posicao,
    required this.fotoAsset,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'bandeira': bandeira,
      'posicao': posicao,
      'foto_asset': fotoAsset,
    };
  }

  factory Jogador.fromMap(Map<String, dynamic> map) {
    return Jogador(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade'],
      bandeira: map['bandeira'],
      posicao: map['posicao'],
      fotoAsset: map['foto_asset'],
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vasco_play.db');


    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE jogadores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        idade INTEGER NOT NULL,
        bandeira TEXT NOT NULL,
        posicao TEXT NOT NULL,
        foto_asset TEXT NOT NULL
      )
    ''');

    final jogadores = [
      Jogador(nome: 'Léo Jardim',        idade: 31, bandeira: '🇧🇷', posicao: 'GK',  fotoAsset: 'assets/jogadores/leo_jardim.png'),
      Jogador(nome: 'Paulo Henrique',     idade: 27, bandeira: '🇧🇷', posicao: 'RB',  fotoAsset: 'assets/jogadores/paulo_henrique.png'),
      Jogador(nome: 'Maicon',            idade: 37, bandeira: '🇧🇷', posicao: 'CB',  fotoAsset: 'assets/jogadores/maicon.png'),
      Jogador(nome: 'Léo',              idade: 34, bandeira: '🇧🇷', posicao: 'CB',  fotoAsset: 'assets/jogadores/leo.png'),
      Jogador(nome: 'Lucas Piton',       idade: 25, bandeira: '🇧🇷', posicao: 'LB',  fotoAsset: 'assets/jogadores/lucas_piton.png'),
      Jogador(nome: 'Mateus Carvalho',   idade: 24, bandeira: '🇧🇷', posicao: 'DM',  fotoAsset: 'assets/jogadores/mateus_carvalho.png'),
      Jogador(nome: 'Hugo Moura',        idade: 25, bandeira: '🇧🇷', posicao: 'CM',  fotoAsset: 'assets/jogadores/hugo_moura.png'),
      Jogador(nome: 'Tchê Tchê',         idade: 32, bandeira: '🇧🇷', posicao: 'CM',  fotoAsset: 'assets/jogadores/tche_tche.png'),
      Jogador(nome: 'Philippe Coutinho', idade: 32, bandeira: '🇧🇷', posicao: 'CAM', fotoAsset: 'assets/jogadores/coutinho.png'),
      Jogador(nome: 'Emerson Rodríguez',idade: 22, bandeira: '🇨🇴', posicao: 'LW',  fotoAsset: 'assets/jogadores/emerson_rodriguez.png'),
      Jogador(nome: 'Vegetti',           idade: 35, bandeira: '🇦🇷', posicao: 'ST',  fotoAsset: 'assets/jogadores/vegetti.png'),
    ];

    final batch = db.batch();
    for (final j in jogadores) {
      batch.insert('jogadores', j.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<Jogador>> getAllJogadores() async {
    final db = await database;
    final maps = await db.query('jogadores', orderBy: 'id ASC');
    return maps.map((m) => Jogador.fromMap(m)).toList();
  }

  Future<Jogador?> getJogadorById(int id) async {
    final db = await database;
    final maps = await db.query('jogadores', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return Jogador.fromMap(maps.first);
  }

  Future<int> insertJogador(Jogador jogador) async {
    final db = await database;
    return await db.insert('jogadores', jogador.toMap());
  }

  Future<int> updateJogador(Jogador jogador) async {
    final db = await database;
    return await db.update('jogadores', jogador.toMap(),
        where: 'id = ?', whereArgs: [jogador.id]);
  }

  Future<int> deleteJogador(int id) async {
    final db = await database;
    return await db.delete('jogadores', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
