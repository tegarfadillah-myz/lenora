import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lenora/models/dokter.dart';
import 'package:lenora/models/article.dart';



class ApiService {
  static const String baseUrl = 'http://192.168.18.14:8000/api';


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
  
}
