//importa o sqlite e o pacote dart pra conseguir rodar em androi de IOS
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


//tabela das caracteristicas do de cada objeto
class CompraCartaoPresente {
  final int? id;
  final String cartao;
  final double preco;
  final String nomeComprador;
  final String formaPagamento;
  final String dataCompra; 

  //construtor onde cria e busca cada objeto 
  CompraCartaoPresente({
    this.id,
    required this.cartao,
    required this.preco,
    required this.nomeComprador,
    required this.formaPagamento,
    required this.dataCompra,
  });

  //transforma em map pois o sqlite não lê em dart
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

  //trasnforma em dart novamente para cantinuar a fazer as outras funçes em dart
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

//funções para saber se ja tem conexão com o banco de dados
class DatabaseHelperCartaoPresente {
  //guarda a única instância que tem
  static final DatabaseHelperCartaoPresente instance =
  DatabaseHelperCartaoPresente._internal();
  static Database? _database;

  //cria a instancia internamente
  DatabaseHelperCartaoPresente._internal();

  
  factory DatabaseHelperCartaoPresente() => instance;

  //para não abrir outra conexão nova com o banco de dados, utilizar a que já tem
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  
  //função para utilizar o banco que já existe para não criar outro e utilizar os mesmos dados
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vasco_cartao_presente.db');

  
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  //cria a tabela do sql para o uso
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

  //insere a compra no banco de dados
  Future<int> insertCompra(CompraCartaoPresente compra) async {
    final db = await database;
    return await db.insert('compras_cartao_presente', compra.toMap());
  }

  //lista as comparas no banco de dados
  Future<List<CompraCartaoPresente>> getAllCompras() async {
    final db = await database;
    final maps =
    await db.query('compras_cartao_presente', orderBy: 'id DESC');
    return maps.map((m) => CompraCartaoPresente.fromMap(m)).toList();
  }

  //função de deletar a compra da lista
  Future<int> deleteCompra(int id) async {
    final db = await database;
    return await db
        .delete('compras_cartao_presente', where: 'id = ?', whereArgs: [id]);
  }

  //fechar o banco de dados
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
