// import 'package:mvvm_project/data/dtos/login/login_request_dto.dart';
// import 'package:mvvm_project/data/dtos/login/login_response_dto.dart';
// import 'package:mvvm_project/data/interfaces/api/iauth_api.dart';
//
// class AuthApi implements IAuthApi{
//   @override
//   Future<LoginResponseDto> login(LoginRequestDto req) async {
//     await Future.delayed(const Duration(microseconds: 600));
//
//     if (req.userName == 'admin' && req.password == '123456') {
//       final json = {
//         'token': 'fake_jwt_abc123',
//         'user': {
//           'id': '1',
//           'userName': 'admin',
//         },
//       };
//       return LoginResponseDto.fromJson(json);
//     }
//     throw Exception('Invalid username or password');
//   }
// }

import 'package:mvvm_project/data/dtos/login/login_request_dto.dart';
import 'package:mvvm_project/data/dtos/login/login_response_dto.dart';
import 'package:mvvm_project/data/dtos/login/user_dto.dart';
import 'package:mvvm_project/data/implementations/local/app_database.dart';
import 'package:mvvm_project/data/implementations/local/password_hasher.dart';
import 'package:mvvm_project/data/interfaces/api/iauth_api.dart';
import 'package:sqflite/sqflite.dart';

class AuthApi implements IAuthApi {
  final AppDatabase database;

  AuthApi(this.database);

  @override
  Future<LoginResponseDto> login(LoginRequestDto req) async {
    final db = await database.db;

    final rows = await db.query(
      'user',
      where: 'username = ?',
      whereArgs: [req.userName],
      limit: 1,
    );

    if (rows.isEmpty) {
      throw Exception('Invalid username or password');
    }

    final userRow = rows.first;
    final storeHash = (userRow['password_hash']).toString();
    final inputHash = PasswordHasher.sha256Hash(req.password);

    if (storeHash != inputHash) {
      throw Exception('Invalid username or password');
    }

    final userId = userRow['id'] as int;
    final token = 'token ${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now().toIso8601String();

    await db.insert('session', {
      'id': 1,
      'user_id': userId,
      'token': token,
      'created_at': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);

    final userDto = UserDto.fromMap(userRow);
    return LoginResponseDto(token: token, user: userDto);
  }

  @override
  Future<LoginResponseDto> getCurrentSession() async {
    final db = await database.db;

    final s = await db.query('session', where: 'id = 1', limit: 1);
    if (s.isEmpty) {
      throw Exception('No active session');
    }

    final sessionRow = s.first;
    final userId = sessionRow['user_id'] as int;
    final token = (sessionRow['token'] ?? '').toString();

    final users = await db.query(
      'user',
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );
    if (users.isEmpty) {
      throw Exception('No active session');
    }

    final userDto = UserDto.fromMap(users.first);
    return LoginResponseDto(token: token, user: userDto);
  }

  @override
  Future<void> logout() async {
    final db = await database.db;
    await db.delete('session', where: 'id = 1');
  }
}

