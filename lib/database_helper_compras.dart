import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Modelo que representa uma compra de plano feita pelo usuário.
class Compra {
  final int? id;
  final String plano;
  final double preco;
  final String nomeComprador;
  final String formaPagamento;
  final String dataCompra; // armazenada em formato ISO8601

  Compra({
    this.id,
    required this.plano,
    required this.preco,
    required this.nomeComprador,
    required this.formaPagamento,
    required this.dataCompra,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'plano': plano,
      'preco': preco,
      'nome_comprador': nomeComprador,
      'forma_pagamento': formaPagamento,
      'data_compra': dataCompra,
    };
  }

  factory Compra.fromMap(Map<String, dynamic> map) {
    return Compra(
      id: map['id'],
      plano: map['plano'],
      preco: map['preco'],
      nomeComprador: map['nome_comprador'],
      formaPagamento: map['forma_pagamento'],
      dataCompra: map['data_compra'],
    );
  }
}

class DatabaseHelperCompras {
  static final DatabaseHelperCompras instance =
  DatabaseHelperCompras._internal();
  static Database? _database;

  DatabaseHelperCompras._internal();

  factory DatabaseHelperCompras() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vasco_compras.db');

    // Diferente do banco de jogadores, este banco NÃO é apagado ao iniciar,
    // pois precisamos manter o histórico de compras entre sessões.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE compras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        plano TEXT NOT NULL,
        preco REAL NOT NULL,
        nome_comprador TEXT NOT NULL,
        forma_pagamento TEXT NOT NULL,
        data_compra TEXT NOT NULL
      )
    ''');
  }

  /// Insere uma nova compra no banco e retorna o id gerado.
  Future<int> insertCompra(Compra compra) async {
    final db = await database;
    return await db.insert('compras', compra.toMap());
  }

  /// Retorna todas as compras, da mais recente para a mais antiga.
  Future<List<Compra>> getAllCompras() async {
    final db = await database;
    final maps = await db.query('compras', orderBy: 'id DESC');
    return maps.map((m) => Compra.fromMap(m)).toList();
  }

  /// Remove uma compra pelo id (útil para "cancelar" um registro de teste).
  Future<int> deleteCompra(int id) async {
    final db = await database;
    return await db.delete('compras', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}