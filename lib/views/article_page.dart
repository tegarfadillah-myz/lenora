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
        Uri.parse('http://192.168.18.14:8000/api/artikel'),
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
    // Calculate the height of the custom app bar
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight =
        statusBarHeight + 48; // Adjusted based on your header height

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content - pushed down to make room for the header
          Positioned(
            top: appBarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false, // Since we're handling the top padding manually
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
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
          ),

          // Custom header that spans the full width
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF0F2D52),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 10,
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/Desain tanpa judul.png',
                        width: 28,
                        height: 28,
                        errorBuilder: (_, __, ___) {
                          return const CircleAvatar(
                            backgroundColor: Color(0xFF0F2D52),
                            child: Text(
                              'S',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SKINEXPERT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chat_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Arahkan ke halaman keranjang
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Arahkan ke halaman keranjang
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Arahkan ke halaman profil
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
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
            ? 'http://192.168.18.14:8000/storage/$thumbnail'
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
