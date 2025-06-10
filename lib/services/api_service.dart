// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lenora/models/dokter.dart';
import 'package:lenora/models/article.dart';
import 'package:lenora/models/produk.dart';


class ApiService {
  // PASTIKAN BASEURL ANDA .
  static const String baseUrl ='http://192.168.18.14:8000/api'; // GANTI DENGAN IP ANDA

  // --- FUNGSI-FUNGSI LAMA ANDA (Sudah ada) ---

  Future<List<Article>> fetchArticles() async {
    final response = await http.get(Uri.parse('$baseUrl/artikel'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List articlesJson = data['data'];
      return articlesJson.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat artikel');
    }
  }

  Future<Article> fetchArticleDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/artikel/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Article.fromJson(data['data']);
    } else {
      throw Exception('Gagal memuat detail artikel');
    }
  }

  Future<List<Dokter>> fetchDokter() async {
    final response = await http.get(Uri.parse('$baseUrl/dokter'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List dokterJson = data['data'];
      return dokterJson.map((json) => Dokter.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat dokter');
    }
  }

  Future<Dokter> fetchDokterDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/dokter/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Dokter.fromJson(data['data']);
    } else {
      throw Exception('Gagal memuat detail dokter');
    }
  }

  Future<List<Produk>> fetchProduk() async {
    final response = await http.get(Uri.parse('$baseUrl/produk'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List produkJson = data['data'];
      return produkJson.map((json) => Produk.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat produk');
    }
  }

  Future<Produk> fetchProdukDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/produk/$id'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Produk.fromJson(data['data']);
    } else {
      throw Exception('Gagal memuat detail produk');
    }
  }

  /// Fungsi untuk Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'email': email, 'password': password}),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == true) {
        return responseData;
      } else {
        throw HttpException(
          responseData['message'] ?? 'Email atau password salah',
        );
      }
    } catch (e) {
      print('Error pada login: $e');
      rethrow;
    }
  }

  /// Fungsi untuk Logout Pengguna
  Future<void> logout(String token) async {
    final url = Uri.parse('$baseUrl/logout');
    try {
      await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      // Abaikan error saat logout, yang penting token di sisi client dihapus
      print('Logout error (diabaikan): $e');
    }
  }
}
