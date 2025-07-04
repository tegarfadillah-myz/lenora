// lib/pages/article_page.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'article_detail_page.dart';
import 'add_article_page.dart'; // MODIFIKASI: Impor halaman baru
import '../widgets/bottomnavbar.dart';

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  List<Article> articles = [];
  Set<Category> categories = {};
  String? errorMessage;
  String? selectedCategory;
  List<Article> allArticles = [];
  bool isLoading = true; // MODIFIKASI: Tambah state loading awal

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    setState(() {
      isLoading = true; // MODIFIKASI: Set loading saat fetch
      errorMessage = null;
    });
    try {
      final response = await http.get(
        Uri.parse('http://172.20.10.5:8000/api/artikel'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];

        setState(() {
          allArticles = data.map((json) => Article.fromJson(json)).toList();
          categories = allArticles
              .map(
                (article) => Category(
                  id: int.parse(article.category.split(':')[0]),
                  name: article.category.split(':')[1],
                ),
              )
              .toSet();
          articles = filterArticles();
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
    } finally {
      setState(() {
        isLoading = false; // MODIFIKASI: Matikan loading setelah selesai
      });
    }
  }

  List<Article> filterArticles() {
    if (selectedCategory == null) {
      return allArticles;
    }
    return allArticles
        .where((article) => article.category.split(':')[0] == selectedCategory)
        .toList();
  }

  void _navigateToDetail(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailPage(articleId: article.id),
      ),
    );
  }

  // MODIFIKASI: Fungsi untuk navigasi ke halaman tambah artikel
  void _navigateToAddArticlePage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddArticlePage(categories: categories.toList()),
      ),
    );

    // Jika result adalah 'true', artinya artikel berhasil dibuat. Refresh list.
    if (result == true) {
      fetchArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = statusBarHeight + 48;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: appBarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    const Text(
                      'Artikel Kesehatan',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category Filter
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: const Text('Semua'),
                                selected: selectedCategory == null,
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedCategory = null;
                                    articles = filterArticles();
                                  });
                                },
                                backgroundColor: Colors.grey[200],
                                selectedColor: const Color(0xFF0F2D52),
                                labelStyle: TextStyle(
                                  color: selectedCategory == null
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            );
                          }

                          final category = categories.elementAt(index - 1);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category.name),
                              selected:
                                  selectedCategory == category.id.toString(),
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedCategory =
                                      selected ? category.id.toString() : null;
                                  articles = filterArticles();
                                });
                              },
                              backgroundColor: Colors.grey[200],
                              selectedColor: const Color(0xFF0F2D52),
                              labelStyle: TextStyle(
                                color:
                                    selectedCategory == category.id.toString()
                                        ? Colors.white
                                        : Colors.black,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: isLoading // MODIFIKASI: Gunakan state isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : errorMessage != null
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      errorMessage!,
                                      style:
                                          const TextStyle(color: Colors.red),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              : articles.isEmpty
                                  ? const Center(
                                      child: Text('Tidak ada artikel.'))
                                  : ListView.builder(
                                      itemCount: articles.length,
                                      padding: const EdgeInsets.only(top: 8),
                                      itemBuilder: (context, index) {
                                        final article = articles[index];
                                        return ArticleCard(
                                          article: article,
                                          onTap: () =>
                                              _navigateToDetail(article),
                                        );
                                      },
                                    ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Custom header (Tidak diubah)
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
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {},
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
      // MODIFIKASI: Tambahkan Floating Action Button di sini
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddArticlePage,
        backgroundColor: const Color(0xFF0F2D52),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// Class Category, Article, dan ArticleCard tetap sama (tidak perlu diubah)
// ...
// ... (sisa kode Anda yang tidak diubah)
// ...

class Category {
  final int id;
  final String name;

  Category({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
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
            ? 'http://172.20.10.5:8000/storage/$thumbnail'
            : 'https://via.placeholder.com/300x200';

    final categoryId = json['category']?['id'] ?? 0;
    final categoryName = json['category']?['name'] ?? 'Uncategorized';

    return Article(
      id: json['id'] ?? 0,
      category: '$categoryId:$categoryName',
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
      child: Container(
        height: 250, // Fixed height for the card
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: SizedBox(
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
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 40,
                          ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category.split(
                        ':',
                      )[1], // Display only category name
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      article.date,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}