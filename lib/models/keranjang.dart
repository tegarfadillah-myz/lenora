import 'package:lenora/models/produk.dart';
// Jangan lupa sesuaikan path import

class Keranjang {
  final int id;
  final int userId;
  final int produkId;
  final int jumlah;
  final Produk produk; // Objek Produk yang berelasi

  Keranjang({
    required this.id,
    required this.userId,
    required this.produkId,
    required this.jumlah,
    required this.produk,
  });

  factory Keranjang.fromJson(Map<String, dynamic> json) {
    return Keranjang(
      id: json['id'],
      userId: json['user_id'],
      produkId: json['produk_id'],
      jumlah: json['jumlah'],
      // Membuat objek Produk dari data JSON 'produk' yang bersarang
      produk: Produk.fromJson(json['produk']),
    );
  }
}

