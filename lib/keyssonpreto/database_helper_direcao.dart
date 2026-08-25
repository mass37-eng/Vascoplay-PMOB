import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class StaffMember {
  final int? id;
  final String nome;
  final int idade;
  final String cargo;
  final String fotoAsset;

  StaffMember({
    this.id,
    required this.nome,
    required this.idade,
    required this.cargo,
    required this.fotoAsset,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'cargo': cargo,
      'foto_asset': fotoAsset,
    };
  }

  factory StaffMember.fromMap(Map<String, dynamic> map) {
    return StaffMember(
      id: map['id'],
      nome: map['nome'],
      idade: map['idade'],
      cargo: map['cargo'],
      fotoAsset: map['foto_asset'],
    );
  }
}

class DatabaseHelperDirecao {
  static final DatabaseHelperDirecao instance = DatabaseHelperDirecao._internal();
  static Database? _database;

  DatabaseHelperDirecao._internal();

  factory DatabaseHelperDirecao() => instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'vasco_direcao.db');

    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE staff (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        idade INTEGER NOT NULL,
        cargo TEXT NOT NULL,
        foto_asset TEXT NOT NULL
      )
    ''');

    final membros = [
      StaffMember(nome: 'Admar Lopes', idade: 42, cargo: 'Diretor Executivo de Futebol', fotoAsset: 'assets/direcao/admar_lopes.png'),
      StaffMember(nome: 'Felipe', idade: 48, cargo: 'Diretor Técnico', fotoAsset: 'assets/direcao/felipe.png'),
      StaffMember(nome: 'Clauber Rocha', idade: 52, cargo: 'Gerente de Futebol', fotoAsset: 'assets/direcao/clauber_rocha.png'),
      StaffMember(nome: 'Sidney Souto', idade: 56, cargo: 'Supervisor', fotoAsset: 'assets/direcao/sidney_souto.png'),
      StaffMember(nome: 'Léo Matos', idade: 40, cargo: 'Gerente Técnico/Transição', fotoAsset: 'assets/direcao/leo_matos.png'),
      StaffMember(nome: 'Bruno Coev', idade:  39, cargo: 'Gerente Administrativo', fotoAsset: 'assets/direcao/bruno_coev.png'),
      StaffMember(nome: 'Renato Gaúcho', idade: 63, cargo: 'Treinador', fotoAsset: 'assets/direcao/renato_gaucho.png'),
      StaffMember(nome: 'Alexandre Mendes', idade: 62, cargo: 'Auxiliar Técnico', fotoAsset: 'assets/direcao/alexandre_mendes.png'),
      StaffMember(nome: 'Nelcirio Franchin', idade: 47, cargo: 'Treinador de Goleiros', fotoAsset: 'assets/direcao/nelcirio_franchin.png'),
      StaffMember(nome: 'Ricardo Bastos', idade: 39, cargo: 'Médico', fotoAsset: 'assets/direcao/ricardo_bastos.png'),
    ];

    final batch = db.batch();
    for (final m in membros) {
      batch.insert('staff', m.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<StaffMember>> getAllStaff() async {
    final db = await database;
    final maps = await db.query('staff', orderBy: 'id ASC');
    return maps.map((m) => StaffMember.fromMap(m)).toList();
  }

  Future<StaffMember?> getStaffById(int id) async {
    final db = await database;
    final maps = await db.query('staff', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return StaffMember.fromMap(maps.first);
  }

  Future<int> insertStaff(StaffMember membro) async {
    final db = await database;
    return await db.insert('staff', membro.toMap());
  }

  Future<int> updateStaff(StaffMember membro) async {
    final db = await database;
    return await db.update('staff', membro.toMap(),
        where: 'id = ?', whereArgs: [membro.id]);
  }

  Future<int> deleteStaff(int id) async {
    final db = await database;
    return await db.delete('staff', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}