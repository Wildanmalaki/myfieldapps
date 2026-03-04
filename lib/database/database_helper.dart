import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> insertUser(UserModel user) async {
  final db = await instance.database;

  return await db.insert(
    'users',
    user.toMap(),
  );
}

Future<UserModel?> loginUser({
  required String email,
  required String password,
}) async {
  final db = await instance.database;

  final result = await db.query(
    'users',
    where: 'email = ? AND password = ?',
    whereArgs: [email, password],
  );

  if (result.isNotEmpty) {
    return UserModel.fromMap(result.first);
  } else {
    return null;
  }
}

Future<UserModel?> getUserByEmail(String email) async {
  final db = await instance.database;

  final result = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
  );

  if (result.isNotEmpty) {
    return UserModel.fromMap(result.first);
  } else {
    return null;
  }
}
}