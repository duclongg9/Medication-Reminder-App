import 'package:mvvm_project/data/implementations/local/password_hasher.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get db async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mvvm_project.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        //user: lưu username + password_hash
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password_hash TEXT NOT NULL
            );
            ''');

        await db.execute('''
          CREATE TABLE session (
            id INTEGER PRIMARY KEY CHECK(id = 1),
            user_id INTEGER NOT NULL,
            token TEXT NOT NULL,
            FOREIGN KEY (user_id) REFERENCES user(id)
            );
            ''');

        await db.insert('user', {
          'username': 'admin',
          'password_hash': PasswordHasher.sha256Hash('FU@2026'),
        });
      },
    );
  }
}

