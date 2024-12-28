import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 2, // Perbarui versi database jika diperlukan
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE biodata(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            address TEXT,
            phone TEXT,
            photo TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE biodata ADD COLUMN photo TEXT');
        }
      },
    );
  }

  // Menambahkan metode queryAllBiodata
  Future<List<Map<String, dynamic>>> queryAllBiodata() async {
    final db = await database;
    return await db.query('biodata'); // Mengambil seluruh data dari tabel biodata
  }

  Future<void> insertBiodata(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('biodata', data);
  }

  Future<void> updateBiodata(Map<String, dynamic> data) async {
    final db = await database;
    await db.update('biodata', data, where: 'id = ?', whereArgs: [data['id']]);
  }

  Future<void> deleteBiodata(int id) async {
    final db = await database;
    await db.delete('biodata', where: 'id = ?', whereArgs: [id]);
  }
}
