import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'article_detail_page.dart';
import 'package:lenora/widgets/bottomnavbar.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<Article> articles = [];
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/artikel'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];

        setState(() {
          articles = data.map((json) => Article.fromJson(json)).toList();
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load articles. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
      print('Exception caught: $e');
    }
  }

  void _navigateToDetail(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(articleId: article.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {},
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'Welcome back,',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Nama Pengguna',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Artikel Kesehatan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child:
                    articles.isEmpty
                        ? Center(
                          child:
                              errorMessage != null
                                  ? Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      errorMessage!,
                                      style: const TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                  : const CircularProgressIndicator(),
                        )
                        : GridView.builder(
                          itemCount: articles.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.65,
                              ),
                          itemBuilder: (context, index) {
                            final article = articles[index];
                            return ArticleCard(
                              article: article,
                              onTap: () => _navigateToDetail(article),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}

class Article {
  final int id;
  final String category;
  final String title;
  final String date;
  final String imageUrl;

  const Article({
    required this.id,
    required this.category,
    required this.title,
    required this.date,
    required this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final String thumbnail = json['thumbnail'] ?? '';
    final String imageUrl =
        thumbnail.isNotEmpty
            ? 'http://127.0.0.1:8000/storage/$thumbnail'
            : 'https://via.placeholder.com/300x200';

    print('Image URL: $imageUrl'); // Untuk debugging

    return Article(
      id: json['id'] ?? 0,
      category: json['category']?['name'] ?? 'Uncategorized',
      title: json['name'] ?? 'No Title',
      date: (json['created_at'] ?? '').substring(0, 10),
      imageUrl: imageUrl,
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 120,
              width: double.infinity,
              child: Image.network(
                article.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                            loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  return Container(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.broken_image, color: Colors.grey, size: 40),
                        SizedBox(height: 4),
                        Text(
                          'Image not available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            article.category,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Text(
            article.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            article.date,
            style: const TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
