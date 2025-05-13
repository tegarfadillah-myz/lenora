// lib/models/dokter.dart

class Produk {
  final int id;
  final String namaProduk;
  final String slug;
  final String deskripsiProduk;
  final String harga;
  final int stok;
  final String? gambarProduk;
  final String namaToko;
  final String kategori;
 

  Produk({
    required this.id,
    required this.namaProduk,
    required this.slug,
    required this.deskripsiProduk,
    required this.harga,
    required this.stok,
    required this.gambarProduk,
    required this.namaToko,
    required this.kategori,

  });
  factory Produk.fromJson(Map<String, dynamic> json) {
  return Produk(
    id: json['id'],
    namaProduk: json['nama_produk'] ?? '',
    slug: json['slug'] ?? '',
    deskripsiProduk: json['deskripsi_produk'] ?? '',
    harga: json['harga'] ?? '',
    stok: json['stok'] ?? 0,
    gambarProduk: json['gambar_produk'] ?? '',
    namaToko: json['nama_toko'] ?? '',
    kategori: json['kategori'] ?? '',
  );
}

}
