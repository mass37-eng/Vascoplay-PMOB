import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Modelo que representa a compra de um cartão presente.
class CompraCartaoPresente {
  final int? id;
  final String cartao;
  final double preco;
  final String nomeComprador;
  final String formaPagamento;
  final String dataCompra; // ISO8601

  CompraCartaoPresente({
    this.id,
    required this.cartao,
    required this.preco,
    required this.nomeComprador,
    required this.formaPagamento,
    required this.dataCompra,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cartao': cartao,
      'preco': preco,
      'nome_comprador': nomeComprador,
      'forma_pagamento': formaPagamento,
      'data_compra': dataCompra,
    };
  }

  factory CompraCartaoPresente.fromMap(Map<String, dynamic> map) {
    return CompraCartaoPresente(
      id: map['id'],
      cartao: map['cartao'],
      preco: map['preco'],
      nomeComprador: map['nome_comprador'],
      formaPagamento: map['forma_pagamento'],
      dataCompra: map['data_compra'],
    );
  }
}

class DatabaseHelperCartaoPresente {
  static final DatabaseHelperCartaoPresente instance =
  DatabaseHelperCartaoPresente._internal();
  static Database? _database;

  DatabaseHelperCartaoPresente._internal();

  factory DatabaseHelperCartaoPresente() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vasco_cartao_presente.db');

    // Esse banco não é apagado ao iniciar, para manter o histórico
    // de cartões presente comprados entre sessões.
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE compras_cartao_presente (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cartao TEXT NOT NULL,
        preco REAL NOT NULL,
        nome_comprador TEXT NOT NULL,
        forma_pagamento TEXT NOT NULL,
        data_compra TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCompra(CompraCartaoPresente compra) async {
    final db = await database;
    return await db.insert('compras_cartao_presente', compra.toMap());
  }

  Future<List<CompraCartaoPresente>> getAllCompras() async {
    final db = await database;
    final maps =
    await db.query('compras_cartao_presente', orderBy: 'id DESC');
    return maps.map((m) => CompraCartaoPresente.fromMap(m)).toList();
  }

  Future<int> deleteCompra(int id) async {
    final db = await database;
    return await db
        .delete('compras_cartao_presente', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}