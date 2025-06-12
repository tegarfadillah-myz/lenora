// lib/services/api_service.dart

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lenora/models/dokter.dart';
import 'package:lenora/models/article.dart';
import 'package:lenora/models/keranjang_response.dart';
import 'package:lenora/models/produk.dart';


class ApiService {
  // PASTIKAN BASEURL ANDA .
  static const String baseUrl ='http://172.20.10.5:8000/api'; // GANTI DENGAN IP ANDA

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
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String namaBelakang,
    required String password,
    String? nohp,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
      'namabelakang': namaBelakang, // Pastikan ini sesuai dengan field di backend
      'nohp': nohp ?? '', // Kirim string kosong jika nohp null
    };
    // Panggil _post untuk mengirim data ke endpoint 'register'
    return await _post('register', body);
  }

  /// Fungsi utilitas untuk POST request yang mengembalikan Map<String, dynamic>
  Future<Map<String, dynamic>> _post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode(body),
    );
    final responseData = json.decode(response.body);
    if (response.statusCode == 200 && (responseData['status'] == true || responseData['success'] == true)) {
      return responseData;
    } else {
      throw HttpException(
        responseData['message'] ?? 'Terjadi kesalahan pada $endpoint',
      );
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

Future<KeranjangResponse> getKeranjang(int userId) async {
    final url = Uri.parse('$baseUrl/keranjang?user_id=$userId');
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );

    // ================== TAMBAHKAN PRINT DI SINI ==================
    print('--- RAW JSON RESPONSE KERANJANG ---');
    print(response.body); // Ini akan mencetak JSON mentah dari server
    // =============================================================

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return KeranjangResponse.fromJson(data);
      } else {
        throw Exception(data['message'] ?? 'Gagal memuat keranjang');
      }
    } else {
      throw Exception(
        'Gagal terhubung ke server (Status code: ${response.statusCode})',
      );
    }
  }


  /// Menambahkan produk ke keranjang (BUTUH TOKEN)
  Future<void> tambahKeKeranjang(int userId, int produkId) async {
    final url = Uri.parse('$baseUrl/keranjang');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      // Body hanya berisi userId dan produkId
      body: json.encode({'user_id': userId, 'produk_id': produkId}),
    );

    // Cek jika request tidak berhasil
    if (response.statusCode != 200) {
      // Melempar error agar bisa ditangkap oleh blok catch di UI
      final responseData = json.decode(response.body);
      throw Exception(responseData['message'] ?? 'Gagal menambahkan produk');
    }
  }


  /// Mengubah jumlah item di keranjang (BUTUH TOKEN)
  Future<void> updateJumlahKeranjang(
    int userId,
    int keranjangId,
    String action,
  ) async {
    final url = Uri.parse('$baseUrl/keranjang/$keranjangId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({'user_id': userId, 'action': action}),
    );
    if (response.statusCode != 200) throw Exception('Gagal memperbarui item');
  }

  Future<void> hapusDariKeranjang(int userId, int keranjangId) async {
    final url = Uri.parse('$baseUrl/keranjang/$keranjangId');
    // NOTE: http.delete tidak standar punya body, jadi kita kirim lewat request object
    final request = http.Request('DELETE', url);
    request.headers.addAll({
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    request.body = json.encode({'user_id': userId});
    final response = await request.send();
    if (response.statusCode != 200) throw Exception('Gagal menghapus item');
  }












}
