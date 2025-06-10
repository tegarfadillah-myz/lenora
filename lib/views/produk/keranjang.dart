import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenora/models/keranjang.dart';
import 'package:lenora/models/keranjang_response.dart';
import 'package:lenora/services/api_service.dart';
import 'package:provider/provider.dart';
import 'package:lenora/services/auth_service.dart';

class KeranjangScreen extends StatefulWidget {
  const KeranjangScreen({super.key});

  @override
  State<KeranjangScreen> createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  // Palet Warna Sesuai Desain
  static const Color primaryColor = Color(0xFF0F2D52);
  // static const Color accentColor = Color(0xFF007BFF); // Biru cerah untuk tombol
  static const Color backgroundColor = Color(
    0xFFF8F9FA,
  ); // Latar belakang off-white

  late final ApiService _apiService;
  Future<KeranjangResponse>? _keranjangFuture;
  int? _userId;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authService = Provider.of<AuthService>(context, listen: false);
      if (authService.isAuthenticated) {
        setState(() {
          _userId = authService.user!.id;
          _fetchKeranjang();
        });
      }
    });
  }

  // --- SEMUA FUNGSI LOGIKA TETAP SAMA ---
  void _fetchKeranjang() {
    if (_userId != null) {
      setState(() {
        _keranjangFuture = _apiService.getKeranjang(_userId!);
      });
    }
  }

  Future<void> _updateItemQuantity(int keranjangId, String action) async {
    if (_userId == null || _isProcessing) return;
    setState(() => _isProcessing = true);
    try {
      await _apiService.updateJumlahKeranjang(_userId!, keranjangId, action);
      _fetchKeranjang();
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _deleteItem(int keranjangId) async {
    if (_userId == null || _isProcessing) return;
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Hapus Item'),
            content: const Text('Anda yakin ingin menghapus item ini?'),
            actions: [
              TextButton(
                child: const Text('Batal'),
                onPressed: () => Navigator.of(ctx).pop(false),
              ),
              TextButton(
                child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                onPressed: () => Navigator.of(ctx).pop(true),
              ),
            ],
          ),
    );
    if (confirmed == true) {
      setState(() => _isProcessing = true);
      try {
        await _apiService.hapusDariKeranjang(_userId!, keranjangId);
        _fetchKeranjang();
      } catch (e) {
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        if (mounted) setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (!authService.isAuthenticated) {
      return Scaffold(
        appBar: _buildAppBar(),
        body: const Center(
          child: Text('Silakan login untuk melihat keranjang Anda.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor, // Diubah: Latar belakang utama
      appBar: _buildAppBar(), // Diubah: Menggunakan AppBar kustom
      body: Stack(
        children: [
          if (_keranjangFuture != null)
            FutureBuilder<KeranjangResponse>(
              future: _keranjangFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Gagal memuat data: ${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
                  return const Center(
                    child: Text('Keranjang Anda masih kosong.'),
                  );
                }
                final keranjangResponse = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    12,
                    12,
                    12,
                    100,
                  ), // Diubah: Padding lebih besar
                  itemCount: keranjangResponse.data.length,
                  itemBuilder: (context, index) {
                    final toko = keranjangResponse.data[index];
                    // Diubah: Desain kartu toko
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            child: Text(
                              toko.namaToko,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          ...toko.items
                              .map((item) => _buildCartItem(item))
                              .toList(),
                        ],
                      ),
                    );
                  },
                );
              },
            )
          else
            const Center(child: CircularProgressIndicator(color: primaryColor)),

          if (_isProcessing)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
      bottomSheet: _buildCheckoutSection(),
    );
  }

  // --- WIDGET HELPER DENGAN DESAIN BARU ---

  PreferredSizeWidget _buildAppBar() {
    // Diubah: AppBar sesuai permintaan Anda
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: primaryColor),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: const Text(
        'KERANJANG SAYA',
        style: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh_outlined, color: primaryColor),
          onPressed: _isProcessing ? null : _fetchKeranjang,
        ),
      ],
    );
  }

  String formatRupiah(int price) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(price);
  }

  String _buildImageUrl(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      return 'http://192.168.18.14:8000/storage/$imagePath';
    }
    return 'https://via.placeholder.com/150';
  }

  Widget _buildCartItem(Keranjang item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              _buildImageUrl(item.produk.gambarProduk),
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey,
                    ),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.produk.namaProduk,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  formatRupiah(item.produk.harga),
                  style: const TextStyle(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [..._buildQuantityControls(item)],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildQuantityControls(Keranjang item) {
    // Diubah: Desain kontrol kuantitas dan hapus
    return [
      _buildQuantityButton(
        icon: Icons.remove,
        onPressed: () => _updateItemQuantity(item.id, 'decrease'),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Text(
          item.jumlah.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      _buildQuantityButton(
        icon: Icons.add,
        onPressed: () => _updateItemQuantity(item.id, 'increase'),
      ),
      const Spacer(),
      IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.grey),
        onPressed: () => _deleteItem(item.id),
        constraints: const BoxConstraints(),
        padding: const EdgeInsets.all(8),
      ),
    ];
  }

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: _isProcessing ? null : onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: _isProcessing ? Colors.grey : primaryColor,
        ),
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return FutureBuilder<KeranjangResponse>(
      future: _keranjangFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.data.isEmpty) {
          return const SizedBox.shrink();
        }
        int totalHarga = 0;
        snapshot.data!.data.forEach((toko) {
          toko.items.forEach((item) {
            totalHarga += item.produk.harga * item.jumlah;
          });
        });

        // Diubah: Desain bagian checkout
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 10,
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Total Pembayaran',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    formatRupiah(totalHarga),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  /* TODO: Navigasi ke halaman Checkout */
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Checkout',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
