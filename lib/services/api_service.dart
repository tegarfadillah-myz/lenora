import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lenora/models/dokter.dart';
import 'package:lenora/models/article.dart';
import 'package:lenora/models/produk.dart';



class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';


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
      throw Exception('Gagal memuat detail artikel');
    }
  }

    Future<List<Produk>> fetchProduk() async {
    final response = await http.get(Uri.parse('$baseUrl/produk'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List produkJson = data['data'];
      return produkJson.map((json) => Produk.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat dokter');
    }
  }
  Future<Produk> fetchProdukDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/produk/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Produk.fromJson(data['data']);
    } else {
      throw Exception('Gagal memuat detail artikel');
    }
  }
  
}
