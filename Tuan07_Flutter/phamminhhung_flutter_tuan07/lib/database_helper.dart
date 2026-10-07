import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('routes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorite_routes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        start_location TEXT NOT NULL,
        end_location TEXT NOT NULL,
        mode TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertRoute(String start, String end, String mode) async {
    final db = await instance.database;
    await db.insert('favorite_routes', {
      'start_location': start,
      'end_location': end,
      'mode': mode,
    });
  }

  Future<List<Map<String, dynamic>>> getRoutes() async {
    final db = await instance.database;
    return await db.query('favorite_routes');
  }
}