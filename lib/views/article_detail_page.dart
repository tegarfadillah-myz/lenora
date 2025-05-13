import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArticleDetailPage extends StatefulWidget {
  final int articleId;

  const ArticleDetailPage({
    super.key,
    required this.articleId,
  });

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  Map<String, dynamic>? articleDetail;
  bool isLoading = true;
  String? errorMessage;
  int likes = 5;
  int comments = 5;
  int shares = 5;
  bool isBookmarked = false;

  final String baseUrl = 'http://192.168.18.9:8000';

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/artikel/${widget.articleId}'));
      print('Fetching article from: $baseUrl/api/artikel/${widget.articleId}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('API Response: $data');
        setState(() {
          articleDetail = data['data'];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load article detail. Status: ${response.statusCode}';
          isLoading = false;
        });
        print('Error response: ${response.body}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('Exception caught: $e');
    }
  }

  String getImageUrl(String? thumbnail) {
    if (thumbnail == null || thumbnail.isEmpty) {
      return 'https://via.placeholder.com/280';
    }
    return '$baseUrl/storage/$thumbnail';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(child: Text(errorMessage!)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F2D52)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'DETAIL ARTIKEL',
          style: TextStyle(
            color: Color(0xFF0F2D52),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Full-height blue background
          Positioned.fill(
            child: Container(color: const Color(0xFF1E293B)),
          ),
          // Make entire content scrollable
          SingleChildScrollView(
            child: Column(
              children: [
                // White section at top
                Container(
                  color: Colors.white,
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            articleDetail?['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // Divider
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Container(
                            height: 1,
                            color: Colors.grey[300],
                          ),
                        ),
                        // Category and date
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            '${articleDetail?['category']?['name'] ?? ''} - ${_formatDate(articleDetail?['created_at'] ?? '')}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1C3F60),
                            ),
                          ),
                        ),
                        // Interaction icons
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              _iconWithCount(Icons.favorite_border, likes),
                              const SizedBox(width: 24),
                              _iconWithCount(Icons.mode_comment_outlined, comments),
                              const SizedBox(width: 24),
                              _iconWithCount(Icons.share_outlined, shares),
                              const Spacer(),
                              IconButton(
                                icon: Icon(
                                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    isBookmarked = !isBookmarked;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Image section with white border
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                    child: Image.network(
                      getImageUrl(articleDetail?['thumbnail']),
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        print('Image error: $error');
                        print('Image URL: ${getImageUrl(articleDetail?['thumbnail'])}');
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                // Content section
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    articleDetail?['content'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
                // Add bottom padding for better scrolling experience
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconWithCount(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return months[month - 1];
  }
}
