import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lenora/models/produk.dart';
import 'package:lenora/views/produk/detail_Produk.dart';
import 'package:lenora/views/produk/keranjang.dart';
import 'package:lenora/widgets/bottomnavbar.dart';

// --- Import yang dibutuhkan ---
import 'package:provider/provider.dart';
import 'package:lenora/services/auth_service.dart';
import 'package:lenora/services/api_service.dart';
import 'package:intl/intl.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

// --- ProductCard diubah untuk menerima fungsi onAddToCart ---
class ProductCard extends StatelessWidget {
  final Produk produk;
  final VoidCallback onTap;
  final VoidCallback onAddToCart; // BARU: Callback untuk tombol keranjang

  const ProductCard({
    super.key,
    required this.produk,
    required this.onTap,
    required this.onAddToCart, // BARU
  });

  // Helper untuk format Rupiah
  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  // Helper untuk membangun URL gambar
  String _buildImageUrl(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return 'http://172.20.10.5:8000/storage/$imagePath';
    }
    return 'https://via.placeholder.com/300x400';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Gambar produk tetap bisa diklik untuk ke detail
          GestureDetector(
            onTap: onTap,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                height: 140,
                width: double.infinity,
                child: Image.network(
                  _buildImageUrl(produk.gambarProduk),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Bagian info produk diubah untuk menyisipkan tombol keranjang
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    produk.namaProduk,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    produk.namaToko,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Stok: ${produk.stok}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 8),
                // DIUBAH: Harga dan Tombol Keranjang dalam satu baris
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      formatRupiah(produk.harga),
                      style: const TextStyle(
                        color: Color(0xFF0F2D52),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // BARU: Tombol ikon untuk tambah keranjang
                    IconButton(
                      icon: const Icon(Icons.add_shopping_cart_outlined),
                      onPressed: onAddToCart,
                      iconSize: 22,
                      color: const Color(0xFF0F2D52),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                      tooltip: 'Tambah ke Keranjang',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductPageState extends State<ProductPage> {
  // State yang dibutuhkan untuk fungsionalitas
  final ApiService _apiService = ApiService(); // BARU
  List<Produk> products = [];
  List<String> categories = [];
  String? selectedCategory;
  String? errorMessage;

  // BARU: State untuk data pengguna yang login
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndProducts();
  }

  Future<void> _loadUserDataAndProducts() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isAuthenticated) {
      _userId = authService.user?.id;
    }
    await fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.20.10.5:8000/api/produk'),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];
        setState(() {
          products = data.map((json) => Produk.fromJson(json)).toList();
          categories = products.map((p) => p.kategori).toSet().toList();
          errorMessage = null;
        });
      } else {
        setState(
          () =>
              errorMessage =
                  'Gagal memuat produk. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      setState(() => errorMessage = 'Terjadi kesalahan: $e');
    }
  }

  // BARU: Fungsi untuk menambah item ke keranjang hanya dengan userId
  Future<void> _addToCart(int produkId) async {
    // Cek apakah user sudah login
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda harus login untuk menambahkan produk.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      // Panggil ApiService yang hanya membutuhkan userId.
      // Pastikan fungsi ini ada di ApiService Anda dan TIDAK memakai token.
      await _apiService.tambahKeKeranjang(_userId!, produkId,);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk berhasil ditambahkan ke keranjang!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan produk: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToDetail(Produk produk) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(produk: produk),
      ),
    );
  }

  void _filterByCategory(String? category) {
    setState(() => selectedCategory = category);
  }

  List<Produk> get filteredProducts {
    if (selectedCategory == null) return products;
    return products.where((p) => p.kategori == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = statusBarHeight + 65;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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
                        errorBuilder:
                            (_, __, ___) => const CircleAvatar(
                              backgroundColor: Color(0xFF0F2D52),
                              child: Text(
                                'S',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                            selectedColor: const Color(0xFF1C3F60),
                            labelStyle: TextStyle(
                              color:
                                  selectedCategory == null
                                      ? Colors.white
                                      : Colors.black87,
                              fontWeight:
                                  selectedCategory == null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
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
                                selectedColor: const Color(0xFF1C3F60),
                                labelStyle: TextStyle(
                                  color:
                                      selectedCategory == cat
                                          ? Colors.white
                                          : Colors.black87,
                                  fontWeight:
                                      selectedCategory == cat
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          products.isEmpty
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
                                          ),
                                        )
                                        : const CircularProgressIndicator(),
                              )
                              : GridView.builder(
                                itemCount: filteredProducts.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio:
                                          0.62, // DIUBAH: Disesuaikan agar tombol muat
                                    ),
                                itemBuilder: (context, index) {
                                  final produk = filteredProducts[index];
                                  return ProductCard(
                                    produk: produk,
                                    onTap: () => _navigateToDetail(produk),
                                    // DIUBAH: Lewatkan fungsi _addToCart ke ProductCard
                                    onAddToCart: () => _addToCart(produk.id),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}
