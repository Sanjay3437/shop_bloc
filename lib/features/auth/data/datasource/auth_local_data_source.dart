
import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  final FlutterSecureStorage storage;

  const AuthLocalDataSourceImpl(this.storage);

  // Read all registered users from secure storage.
  Future<Map<String, dynamic>> _readUsers() async {
    final raw = await storage.read(key: _usersKey);

    if (raw == null || raw.isEmpty) {
      return {};
    }

    return Map<String, dynamic>.from(
      jsonDecode(raw) as Map,
    );
  }

  // Save all registered users to secure storage.
  Future<void> _writeUsers(
      Map<String, dynamic> users,
      ) async {
    await storage.write(
      key: _usersKey,
      value: jsonEncode(users),
    );
  }

  // Generate a random salt for password hashing.
  String _newSalt() {
    final random = Random.secure();

    return base64UrlEncode(
      List<int>.generate(
        16,
            (_) => random.nextInt(256),
      ),
    );
  }

  // Hash the password together with its salt.
  String _hash(String password, String salt) {
    return sha256
        .convert(utf8.encode('$salt$password'))
        .toString();
  }

  // Normalize email so uppercase/lowercase differences don't matter.
  String _normalize(String email) {
    return email.trim().toLowerCase();
  }

  @override
  Future<AuthUserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final key = _normalize(email);
    final users = await _readUsers();

    if (users.containsKey(key)) {
      throw const AuthException(
        'An account with this email already exists',
      );
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

    // Save the current login session securely.
    await storage.write(
      key: _sessionKey,
      value: key,
    );

    return AuthUserModel(
      name: cleanName,
      email: key,
    );
  }

  @override
  Future<AuthUserModel> signIn({
    required String email,
    required String password,
  }) async {
    final key = _normalize(email);
    final users = await _readUsers();

    final record = users[key] as Map<String, dynamic>?;

    // Use the same error for an unknown email and a wrong password.
    if (record == null ||
        record['hash'] !=
            _hash(password, record['salt'] as String)) {
      throw const AuthException(
        'Invalid email or password',
      );
    }

    // Save the current login session securely.
    await storage.write(
      key: _sessionKey,
      value: key,
    );

    return AuthUserModel.fromJson(record);
  }

  @override
  Future<void> signOut() async {
    await storage.delete(key: _sessionKey);
  }

  @override
  Future<AuthUserModel?> getCurrentUser() async {
    final key = await storage.read(key: _sessionKey);

    if (key == null) {
      return null;
    }

    final users = await _readUsers();
    final record = users[key] as Map<String, dynamic>?;

    if (record == null) {
      // Remove a session that no longer has a matching user.
      await storage.delete(key: _sessionKey);
      return null;
    }

    return AuthUserModel.fromJson(record);
  }
}