// lib/services/auth_service.dart

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:lenora/models/user.dart'; // Make sure this path matches where your User class is defined
import 'package:lenora/services/api_service.dart';

class AuthService with ChangeNotifier {
  String? _token;
  User? _user;
  final ApiService _apiService = ApiService();

  String? get token => _token;
  User? get user => _user;
  bool get isAuthenticated => _token != null;

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.login(email, password);
      if (response['status'] == true) {
        _token = response['token'];
        _user = User.fromJson(response['user']);

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('authToken', _token!);
        // Simpan data user sebagai string JSON
        prefs.setString('userData', jsonEncode(response['user']));

        notifyListeners();
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? nohp, required String namaBelakang,
  }) async {
    try {
      await _apiService.register(
        name: name,
        email: email,
        password: password,
        nohp: nohp,
        namaBelakang: '',
      );
      // Setelah registrasi berhasil, langsung login
      await login(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    if (_token != null) {
      await _apiService.logout(_token!);
    }
    _token = null;
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userData');

    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authToken')) {
      return;
    }

    _token = prefs.getString('authToken');
    // Ambil data user dari SharedPreferences
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      _user = User.fromJson(jsonDecode(userDataString));
    }

    notifyListeners();
  }
}
