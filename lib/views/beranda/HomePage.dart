import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lenora/views/produk/keranjang.dart';
import 'package:provider/provider.dart';

// Import Model Anda
import 'package:lenora/models/dokter.dart';
import 'package:lenora/models/article.dart';
import 'package:lenora/models/produk.dart';

// Import Provider Anda
import 'package:lenora/services/auth_service.dart';

// Import View/Page Anda
import 'package:lenora/views/dokter/DokterDetail.dart';
import 'package:lenora/views/article_detail_Page.dart';
import 'package:lenora/views/produk/detail_Produk.dart';
import 'package:lenora/views/auth/login_page.dart';
import 'package:lenora/views/produk/produk.dart' as produk_page;
import 'package:lenora/views/article_page.dart' as article_page;
import 'package:lenora/views/dokter/dokter.dart' as dokter_page;

// Import Widget Anda
import 'package:lenora/widgets/bottomnavbar.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Fungsi untuk mengambil data Dokter dari API
  Future<List<Dokter>> fetchDokter() async {
    final response = await http.get(
      Uri.parse('http://192.168.18.14:8000/api/dokter'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> dokterJson = json.decode(response.body)['data'];
      return dokterJson.map((json) => Dokter.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data dokter');
    }
  }

  // Fungsi untuk mengambil data Artikel dari API
  Future<List<Article>> fetchArtikel() async {
    final response = await http.get(
      Uri.parse('http://192.168.18.14:8000/api/artikel'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data artikel');
    }
  }

  // Fungsi untuk mengambil data Produk dari API
  Future<List<Produk>> fetchProduk() async {
    final response = await http.get(
      Uri.parse('http://192.168.18.14:8000/api/produk'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Produk.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data produk');
    }
  }

  // Widget untuk membuat chip kategori
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
    // Anda bisa mendapatkan nama pengguna dari provider jika tersedia
    // final userName = Provider.of<AuthProvider>(context).user?.name ?? 'Pengguna';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Bagian Header Biru & Pencarian
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
                        'Fadly Agus Mulianta', // Ganti dengan `userName` jika sudah ada
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
                          itemCount: 3, // Jumlah banner
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

              // Bagian Konten Putih dengan sudut melengkung
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

                      // Judul Daftar Dokter
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Daftar Dokter',
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
                                        (context) => dokter_page.DoctorPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
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
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => DoctorDetailPage(
                                                  dokter: dokter,
                                                ),
                                          ),
                                        ),
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
                                              dokter.foto.isNotEmpty
                                                  ? 'http://192.168.18.14:8000/storage/${dokter.foto}'
                                                  : 'https://via.placeholder.com/160x120',
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => Container(
                                                    height: 120,
                                                    color: Colors.grey.shade200,
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "Sp. ${dokter.spesialisasi}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                      size: 16,
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

                      // Judul Artikel Kesehatan
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
                              onPressed:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              article_page.ArticlePage(),
                                    ),
                                  ),
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
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
                            final displayedArticles =
                                artikelList.length > 5
                                    ? artikelList.sublist(0, 5)
                                    : artikelList;
                            return SizedBox(
                              height: 200,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                itemCount: displayedArticles.length,
                                separatorBuilder:
                                    (_, __) => SizedBox(width: 20),
                                itemBuilder: (context, index) {
                                  final artikel = displayedArticles[index];
                                  return GestureDetector(
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ArticleDetailPage(
                                                  articleId: artikel.id,
                                                ),
                                          ),
                                        ),
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
                                                  ? 'http://192.168.18.14:8000/storage/${artikel.thumbnail}'
                                                  : 'https://via.placeholder.com/220x100',
                                              height: 100,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (c, e, s) => Container(
                                                    height: 100,
                                                    color: Colors.grey.shade200,
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  artikel.name,
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

                      // Judul Produk Skincare
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
                              onPressed:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              produk_page.ProductPage(),
                                    ),
                                  ),
                              child: Text(
                                'Lihat Semua',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // List Produk (Horizontal)
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
                                    onTap:
                                        () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => ProductDetailPage(
                                                  produk: produk,
                                                ),
                                          ),
                                        ),
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
                                                  ? 'http://192.168.18.14:8000/storage/${produk.gambarProduk}'
                                                  : 'https://via.placeholder.com/160x120',
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (c, e, s) => Container(
                                                    height: 120,
                                                    color: Colors.grey.shade200,
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color:
                                                          Colors.grey.shade400,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  produk.namaProduk,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  "Rp ${produk.harga.toString()}",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color(
                                                      0xFF0F2D52,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Stok: ${produk.stok.toString()}',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey,
                                                  ),
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

                      // === TOMBOL LOGOUT ===
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 40.0,
                        ),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade400,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 50,
                                vertical: 15,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () async {
                              // Tampilkan dialog konfirmasi
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Konfirmasi Logout"),
                                    content: Text(
                                      "Apakah Anda yakin ingin logout?",
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Batal"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Logout",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          // Tutup dialog
                                          Navigator.of(context).pop();

                                          // Panggil fungsi logout dari AuthProvider
                                          await Provider.of<AuthService>(
                                            context,
                                            listen: false,
                                          ).logout();

                                          // Arahkan ke halaman login dan hapus semua halaman sebelumnya
                                          if (mounted) {
                                            Navigator.of(
                                              context,
                                            ).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => LoginPage(),
                                              ),
                                              (Route<dynamic> route) => false,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Text('Logout'),
                          ),
                        ),
                      ),

                      // === AKHIR TOMBOL LOGOUT ===
                      const SizedBox(
                        height: 70,
                      ), // Space untuk bottom navigation bar
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Header sticky di atas
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
                          /* TODO: Arahkan ke halaman chat */
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // 1. Ambil instance AuthService menggunakan Provider
                          // listen: false karena kita hanya butuh memanggil data, tidak perlu me-rebuild widget ini
                          final authService = Provider.of<AuthService>(
                            context,
                            listen: false,
                          );

                          // 2. Cek status login dari AuthService
                          if (authService.isAuthenticated &&
                              authService.user != null) {
                            // 3. Ambil userId langsung dari objek user yang ada di AuthService
                            final int userId = authService.user!.id;

                            print(
                              'Berhasil mendapatkan userId: $userId. Navigasi ke keranjang...',
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                // Panggil KeranjangScreen tanpa argumen apapun.
                                // Halaman ini akan mengambil data login sendiri.
                                builder: (context) => const KeranjangScreen(),
                              ),
                            );
                          } else {
                            // 4. Jika user tidak ditemukan di AuthService, tampilkan pesan
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Anda harus login terlebih dahulu.',
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          /* TODO: Arahkan ke halaman profil */
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
