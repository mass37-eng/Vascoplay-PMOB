import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Compra {
  final int? id;
  final String plano;
  final double preco;
  final String nomeComprador;
  final String formaPagamento;
  final String dataCompra;

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
  Database? _database;

  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vasco_compras.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );

    return _database!;
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

  Future<int> insertCompra(Compra compra) async {
    final db = await getDatabase();
    return await db.insert('compras', compra.toMap());
  }

  Future<List<Compra>> getAllCompras() async {
    final db = await getDatabase();
    final maps = await db.query('compras', orderBy: 'id DESC');

    List<Compra> compras = [];

    for (var m in maps) {
      compras.add(Compra.fromMap(m));
    }

    return compras;
  }

  Future<int> deleteCompra(int id) async {
    final db = await getDatabase();
    return await db.delete(
      'compras',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await getDatabase();
    db.close();
  }
}
