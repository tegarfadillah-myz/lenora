import 'package:flutter/material.dart';
import '../../models/produk.dart';
import 'package:lenora/views/produk/pembayaran_Produk.dart';

class ProductDetailPage extends StatefulWidget {
  final Produk produk;

  const ProductDetailPage({Key? key, required this.produk}) : super(key: key);

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int quantity = 1;
  int selectedSizeIndex = 0;
  bool isFavorite = false;
  final String baseUrl = 'http://172.20.10.5:8000';
  final List<String> availableSizes = ['30ml', '50ml', '100ml'];

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void selectSize(int index) {
    setState(() {
      selectedSizeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final produk = widget.produk;

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
          'DETAIL PRODUK',
          style: TextStyle(
            color: Color(0xFF0F2D52),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(produk),
                  _buildProductInfo(produk),
                  _buildSizeSelector(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          _buildAddToCartSection(produk), 
        ],
      ),
    );
  }

 

  Widget _buildProductImage(Produk produk) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 250,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Image.network(
          produk.gambarProduk != null && produk.gambarProduk!.isNotEmpty
              ? 'http://192.168.18.14:8000/storage/${produk.gambarProduk}'
              : 'https://via.placeholder.com/300x400',
          height: 200,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image, size: 60, color: Colors.grey);
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo(Produk produk) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          produk.namaProduk,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Rp. ${produk.harga}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          produk.deskripsiProduk,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    ),
  );
}


  Widget _buildSizeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pilih Ukuran:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(
              availableSizes.length,
              (index) => GestureDetector(
                onTap: () => selectSize(index),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedSizeIndex == index ? const Color(0xFF1C3A5D) : Colors.white,
                    border: Border.all(color: const Color(0xFF1C3A5D)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    availableSizes[index],
                    style: TextStyle(
                      color: selectedSizeIndex == index ? Colors.white : const Color(0xFF1C3A5D),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartSection( Produk produk) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: decrementQuantity,
                  icon: const Icon(Icons.remove),
                ),
                Text(quantity.toString(), style: const TextStyle(fontSize: 16)),
                IconButton(
                  onPressed: incrementQuantity,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BayarProdukPage(produk: produk),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C3A5D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'BELI SEKARANG',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

        ],
      ),
    );
  }
}