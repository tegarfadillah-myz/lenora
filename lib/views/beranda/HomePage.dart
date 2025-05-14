import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lenora/models/dokter.dart';
import 'package:lenora/models/article.dart';
import 'package:lenora/models/produk.dart';
import 'package:lenora/views/dokter/DokterDetail.dart';
import 'package:lenora/views/article_detail_Page.dart'; // Ensure this file contains the ArticleDetailPage class
import 'package:lenora/views/produk/detail_Produk.dart';
import 'package:lenora/views/produk/produk.dart' as produk_page;
// import 'package:lenora/views/article_page.dart';
import 'package:lenora/widgets/bottomnavbar.dart';
import 'package:lenora/views/article_page.dart' as article_page;
// Ensure this file contains the ProductPage class

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Dokter>> fetchDokter() async {
    final response = await http.get(
      Uri.parse('http://192.168.18.9:8000/api/dokter'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> dokterJson = json.decode(response.body)['data'];
      return dokterJson.map((json) => Dokter.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data dokter');
    }
  }

  Future<List<Article>> fetchArtikel() async {
    final response = await http.get(
      Uri.parse('http://192.168.18.9:8000/api/artikel'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data artikel');
    }
  }

  Future<List<Produk>> fetchProduk() async {
    final response = await http.get(
      Uri.parse('http://192.168.18.9:8000/api/produk'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Produk.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data produk');
    }
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header & Search
              SliverToBoxAdapter(
                child: Container(
                  color: const Color(0xFF0F2D52),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).padding.top + 70),
                      const Text(
                        'Selamat Datang Di SkinExpert',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const Text(
                        'Fadly Agus Mulianta',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari Produk & Dokter',
                            border: InputBorder.none,
                            icon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(right: 12),
                              width: 280,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/pexels-shvetsa-4226256.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              // Konten Putih (rounded)
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 20, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Kategori Dokter
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            _buildCategoryChip('All Dokter', true),
                            _buildCategoryChip('Spesialis Kulit', false),
                            _buildCategoryChip('Kecantikan', false),
                            _buildCategoryChip('Anti Aging', false),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Judul Dokter
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 16),
                        child: Text(
                          'Daftar Dokter',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      // List Dokter (Horizontal)
                      FutureBuilder<List<Dokter>>(
                        future: fetchDokter(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Gagal memuat data dokter'),
                            );
                          } else {
                            final dokterList = snapshot.data!;
                            return SizedBox(
                              height: 230,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: dokterList.length,
                                separatorBuilder:
                                    (_, __) => SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final dokter = dokterList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => DoctorDetailPage(
                                                dokter: dokter,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 160,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.2,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                            child: Image.network(
                                              dokter.foto.isNotEmpty
                                                  ? 'http://192.168.18.9:8000/storage/${dokter.foto}'
                                                  : 'https://via.placeholder.com/300x400',
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  height: 120,
                                                  color: Colors.grey.shade200,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Dr. ${dokter.namaDokter}",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  "Spesialis: ${dokter.spesialisasi}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                          size: 14,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          '${dokter.rating}',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(
                                                      Icons.add_circle_outline,
                                                      size: 18,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(height: 24),

                      // Judul Artikel dengan tombol Lihat Semua
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Artikel Kesehatan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => article_page.ArticlePage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(
                                    255,
                                    107,
                                    107,
                                    107,
                                  ),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // List Artikel (Horizontal)
                      FutureBuilder<List<Article>>(
                        future: fetchArtikel(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Gagal memuat data artikel'),
                            );
                          } else {
                            final artikelList = snapshot.data!;
                            // Hanya tampilkan 5 artikel pertama
                            final displayedArticles =
                                artikelList.length > 5
                                    ? artikelList.sublist(0, 5)
                                    : artikelList;

                            return SizedBox(
                              height: 180,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: displayedArticles.length,
                                separatorBuilder:
                                    (_, __) => SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final artikel = displayedArticles[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ArticleDetailPage(
                                                articleId: artikel.id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 220,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                            child: Image.network(
                                              artikel.thumbnail.isNotEmpty
                                                  ? 'http://192.168.18.9:8000/storage/${artikel.thumbnail}'
                                                  : 'https://via.placeholder.com/300x400',
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  height: 100,
                                                  color: Colors.grey.shade200,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${artikel.name.substring(0, artikel.name.length > 15 ? 15 : artikel.name.length)}${artikel.name.length > 15 ? '...' : ''}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  artikel.content,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Produk Skincare',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => produk_page.ProductPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color.fromARGB(255, 107, 107, 107),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // List Artikel (Horizontal)
                      FutureBuilder<List<Produk>>(
                        future: fetchProduk(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Gagal memuat data produk'),
                            );
                          } else {
                            final produkList = snapshot.data!;
                            // Hanya tampilkan 5 artikel pertama
                            final displayedProduks =
                                produkList.length > 5
                                    ? produkList.sublist(0, 5)
                                    : produkList;

                            return SizedBox(
                              height: 250,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: displayedProduks.length,
                                separatorBuilder:
                                    (_, __) => SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final produk = displayedProduks[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailPage(
                                            produk: produk,
                                          ), 
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: 160,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.1,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                            child: Image.network(
                                              produk.gambarProduk != null &&
                                                      produk
                                                          .gambarProduk!
                                                          .isNotEmpty
                                                  ? 'http://192.168.18.9:8000/storage/${produk.gambarProduk}'
                                                  : 'https://via.placeholder.com/300x400',
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (
                                                context,
                                                error,
                                                stackTrace,
                                              ) {
                                                return Container(
                                                  height: 120,
                                                  color: Colors.grey.shade200,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${produk.namaProduk.substring(0, produk.namaProduk.length > 15 ? 15 : produk.namaProduk.length)}${produk.namaProduk.length > 15 ? '...' : ''}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                // SizedBox(height: 4),
                                                Text(
                                                  "Rp ${produk.harga.toString()}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: const Color.fromARGB(
                                                      255,
                                                      0,
                                                      0,
                                                      0,
                                                    ),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Stok: ${produk.stok.toString()}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Toko: ${produk.namaToko}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                      

                      const SizedBox(
                        height: 70,
                      ), // Tambahkan space di bawah untuk bottom navigation bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Header (Sticky Title)
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
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }
}
