import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/models/user_model.dart';

class AuthService {
  static const String _userKey = 'user';
  static const String _tokenKey = 'token';

  static Future<void> saveUser(UserModel user) async {
    debugPrint('Saving user: ${user.toString()}');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    debugPrint('Retrieved user JSON: $userJson');

    if (userJson != null) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      debugPrint('Retrieved user: ${user.toString()}');
      return user;
    }
    return null;
  }

  static Future<void> saveAuthData({
    required String token,
    required UserModel user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }
}
