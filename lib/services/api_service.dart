import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

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
}
