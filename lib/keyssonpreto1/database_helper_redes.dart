import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RedesSociais {
  int? id;
  String instagram;
  String x;
  String tiktok;
  String facebook;

  RedesSociais({
    this.id,
    required this.instagram,
    required this.x,
    required this.tiktok,
    required this.facebook,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'instagram': instagram,
      'x': x,
      'tiktok': tiktok,
      'facebook': facebook,
    };
  }

  factory RedesSociais.fromMap(Map<String, dynamic> map) {
    return RedesSociais(
      id: map['id'],
      instagram: map['instagram'],
      x: map['x'],
      tiktok: map['tiktok'],
      facebook: map['facebook'],
    );
  }
}

class DatabaseHelper {
  static Database? _banco;

  static Future<Database> getBanco() async {
    if (_banco != null) return _banco!;
    String caminho = await getDatabasesPath();
    String endereco = join(caminho, 'redes.db');
    _banco = await openDatabase(
      endereco,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE redes_sociais (
            id INTEGER PRIMARY KEY,
            instagram TEXT,
            x TEXT,
            tiktok TEXT,
            facebook TEXT
          )
        ''');
        await db.insert('redes_sociais', {
          'id': 1,
          'instagram': '',
          'x': '',
          'tiktok': '',
          'facebook': '',
        });
      },
    );
    return _banco!;
  }
}

class RedesDao {
  static Future<RedesSociais> buscar() async {
    Database db = await DatabaseHelper.getBanco();
    List<Map<String, dynamic>> resultado = await db.query('redes_sociais', where: 'id = ?', whereArgs: [1]);
    return RedesSociais.fromMap(resultado.first);
  }

  static Future<void> salvar(RedesSociais redes) async {
    Database db = await DatabaseHelper.getBanco();
    await db.update(
      'redes_sociais',
      redes.toMap(),
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  static Future<void> limpar() async {
    Database db = await DatabaseHelper.getBanco();
    await db.update(
      'redes_sociais',
      {'instagram': '', 'x': '', 'tiktok': '', 'facebook': ''},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}