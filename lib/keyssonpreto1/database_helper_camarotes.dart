import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CamaroteRegistro {
  int? id;
  String nome;
  String cpf;
  String plano;
  String preco;
  String formaPagamento;

  CamaroteRegistro({
    this.id,
    required this.nome,
    required this.cpf,
    required this.plano,
    required this.preco,
    required this.formaPagamento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'plano': plano,
      'preco': preco,
      'forma_pagamento': formaPagamento,
    };
  }

  factory CamaroteRegistro.fromMap(Map<String, dynamic> map) {
    return CamaroteRegistro(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      plano: map['plano'],
      preco: map['preco'],
      formaPagamento: map['forma_pagamento'],
    );
  }
}

class DatabaseHelper {
  static Database? _banco;

  static Future<Database> getBanco() async {
    if (_banco != null) return _banco!;
    String caminho = await getDatabasesPath();
    String endereco = join(caminho, 'camarotes.db');
    _banco = await openDatabase(
      endereco,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE camarotes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            cpf TEXT,
            plano TEXT,
            preco TEXT,
            forma_pagamento TEXT
          )
        ''');
      },
    );
    return _banco!;
  }
}

class CamaroteDao {
  static Future<int> inserir(CamaroteRegistro registro) async {
    Database db = await DatabaseHelper.getBanco();
    int id = await db.insert('camarotes', registro.toMap());
    return id;
  }

  static Future<List<CamaroteRegistro>> buscarTodos() async {
    Database db = await DatabaseHelper.getBanco();
    List<Map<String, dynamic>> resultado = await db.query('camarotes', orderBy: 'id DESC');
    List<CamaroteRegistro> lista = [];
    for (Map<String, dynamic> item in resultado) {
      lista.add(CamaroteRegistro.fromMap(item));
    }
    return lista;
  }

  static Future<void> deletar(int id) async {
    Database db = await DatabaseHelper.getBanco();
    await db.delete('camarotes', where: 'id = ?', whereArgs: [id]);
  }
}