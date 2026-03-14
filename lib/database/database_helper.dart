import 'package:MyField/models/booking_model.dart';
import 'package:MyField/models/user_model.dart';
import 'package:MyField/fieldreview/models/field_review_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('myfield.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {

  await db.execute('''
  CREATE TABLE users(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email TEXT,
    password TEXT
  )
  ''');

  await db.execute('''
  CREATE TABLE bookings(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userId INTEGER,
    lapangan TEXT,
    tanggal TEXT,
    waktu TEXT,
    status TEXT,
    harga TEXT
  )
  ''');

  await db.execute('''
  CREATE TABLE reviews(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fieldName TEXT,
    reviewer TEXT,
    comment TEXT,
    rating INTEGER,
    date TEXT
  )
  ''');
}

  // ================= USER =================

  Future<int> insertUser(UserModel user) async {
    final db = await database;
    return db.insert('users', user.toMap());
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final db = await database;

    final result = await db.query(
      "users",
      where: "email=? AND password=?",
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }

    return null;
  }

  

  // ================= BOOKING =================

  Future<int> insertBooking(Booking booking) async {
    final db = await database;
    return db.insert("bookings", booking.toMap());
  }

  Future<List<Booking>> getBookings() async {
    final db = await database;
    final result = await db.query("bookings");
    return result.map((e) => Booking.fromMap(e)).toList();
  }

  Future<int> deleteBooking(int id) async {
    final db = await database;
    return db.delete("bookings", where: "id=?", whereArgs: [id]);
  }

  // ================= REVIEW =================

  Future<int> insertReview(FieldReview review) async {
    final db = await database;
    return db.insert("reviews", review.toMap());
  }

  Future<List<FieldReview>> getReviews() async {
    final db = await database;
    final result = await db.query("reviews", orderBy: "id DESC");
    return result.map((e) => FieldReview.fromMap(e)).toList();
  }

  Future<int> deleteReview(int id) async {
    final db = await database;
    return db.delete("reviews", where: "id=?", whereArgs: [id]);
  }
  

  Future<UserModel?> getUserByEmail(String email) async {

  final db = await database;

  final result = await db.query(
    "users",
    where: "email = ?",
    whereArgs: [email],
  );

  if (result.isNotEmpty) {
    return UserModel.fromMap(result.first);
  }

  return null;
}
}