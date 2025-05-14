import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lenora/models/produk.dart';
import 'package:lenora/views/produk/detail_Produk.dart';
import 'package:lenora/widgets/bottomnavbar.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class ProductCard extends StatelessWidget {
  final Produk produk;
  final VoidCallback onTap;
  final String baseUrl = 'http://192.168.18.9:8000';
  const ProductCard({super.key, required this.produk, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 140,
                width: double.infinity,
                child: Image.network(
                  produk.gambarProduk !=null && produk.gambarProduk!.isNotEmpty
                      ? 'http://192.168.18.9:8000/storage/${produk.gambarProduk}'
                      : 'https://via.placeholder.com/300x400',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produk.namaProduk,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${produk.harga}',
                    style: const TextStyle(color: Colors.black87, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    produk.kategori,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductPageState extends State<ProductPage> {
  List<Produk> products = [];
  List<String> categories = [];
  String? selectedCategory;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.18.9:8000/api/produk'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];

        setState(() {
          products = data.map((json) => Produk.fromJson(json)).toList();
          categories = products.map((p) => p.kategori).toSet().toList();
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal memuat produk. Status: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
      });
    }
  }

  void _navigateToDetail(Produk produk) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProductDetailPage(produk: produk)),
    );
  }

  void _filterByCategory(String? category) {
    setState(() {
      selectedCategory = category;
    });
  }

  List<Produk> get filteredProducts {
    if (selectedCategory == null) return products;
    return products.where((p) => p.kategori == selectedCategory).toList();
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
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Produk Skincare',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          FilterChip(
                            label: const Text('Semua'),
                            selected: selectedCategory == null,
                            onSelected: (_) => _filterByCategory(null),
                            backgroundColor: Colors.grey[200],
                            selectedColor: Colors.blue[100],
                            labelStyle: TextStyle(
                              color: selectedCategory == null ? Colors.blue : Colors.black87,
                              fontWeight: selectedCategory == null ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...categories.map(
                            (cat) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(cat),
                                selected: selectedCategory == cat,
                                onSelected: (_) => _filterByCategory(cat),
                                backgroundColor: Colors.grey[200],
                                selectedColor: Colors.blue[100],
                                labelStyle: TextStyle(
                                  color: selectedCategory == cat ? Colors.blue : Colors.black87,
                                  fontWeight: selectedCategory == cat ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: products.isEmpty
                          ? Center(
                              child: errorMessage != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                                    )
                                  : const CircularProgressIndicator(),
                            )
                          : GridView.builder(
                              itemCount: filteredProducts.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.7,
                              ),
                              itemBuilder: (context, index) {
                                final produk = filteredProducts[index];
                                return ProductCard(
                                  produk: produk,
                                  onTap: () => _navigateToDetail(produk),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                            child: Text('S', style: TextStyle(color: Colors.white)),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SKINEXPERT',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_rounded, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart, color: Colors.white),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.account_circle, color: Colors.white),
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
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}