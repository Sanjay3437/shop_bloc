import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_bloc/core/exceptions/app_exceptions.dart';
import '../models/auth_user_model.dart';

abstract class AuthLocalDataSource {
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  });

  Future<AuthUserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<AuthUserModel?> getCurrentUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _usersKey = 'auth_users';
  static const _sessionKey = 'auth_session';

  final SharedPreferences prefs;

  const AuthLocalDataSourceImpl(this.prefs);

  Map<String, dynamic> _readUsers() {
    final raw = prefs.getString(_usersKey);
    if (raw == null) return {};
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> _writeUsers(Map<String, dynamic> users) async {
    await prefs.setString(_usersKey, jsonEncode(users));
  }

  String _newSalt() {
    final random = Random.secure();
    return base64UrlEncode(List<int>.generate(16, (_) => random.nextInt(256)));
  }

  String _hash(String password, String salt) {
    return sha256.convert(utf8.encode('$salt$password')).toString();
  }

  String _normalize(String email) => email.trim().toLowerCase();

  @override
  Future<AuthUserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final key = _normalize(email);
    final users = _readUsers();

    if (users.containsKey(key)) {
      throw const AuthException('An account with this email already exists');
    }

    final salt = _newSalt();
    final cleanName = name.trim();
    users[key] = {
      'name': cleanName,
      'email': key,
      'salt': salt,
      'hash': _hash(password, salt),
    };

    await _writeUsers(users);
    await prefs.setString(_sessionKey, key);
    return AuthUserModel(name: cleanName, email: key);
  }

  @override
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    final key = _normalize(email);
    final record = _readUsers()[key] as Map<String, dynamic>?;

    // Same message for "no such user" and "wrong password", so the
    // error doesn't reveal which emails are registered.
    if (record == null ||
        record['hash'] != _hash(password, record['salt'] as String)) {
      throw const AuthException('Invalid email or password');
    }

    await prefs.setString(_sessionKey, key);
    return AuthUserModel.fromJson(record);
  }

  @override
  Future<void> signOut() async {
    await prefs.remove(_sessionKey);
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final key = prefs.getString(_sessionKey);
    if (key == null) return null;

    final record = _readUsers()[key] as Map<String, dynamic>?;
    if (record == null) {
      await prefs.remove(_sessionKey); // stale session
      return null;
    }
    return AuthUserModel.fromJson(record);
  }
}