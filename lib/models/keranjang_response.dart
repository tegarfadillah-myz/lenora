import 'package:lenora/models/keranjang.dart';
// Sesuaikan path jika perlu

// Model untuk merepresentasikan satu grup toko dengan item-itemnya
class KeranjangToko {
  final String namaToko;
  final List<Keranjang> items;

  KeranjangToko({required this.namaToko, required this.items});
}

// Model untuk menangani keseluruhan respons dari API getKeranjang
class KeranjangResponse {
  final List<KeranjangToko> data;
  final int totalJumlah;

  KeranjangResponse({required this.data, required this.totalJumlah});

  // Bagian factory diubah untuk menangani konversi tipe data
  factory KeranjangResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> dataMap = json['data'] ?? {};
    final List<KeranjangToko> keranjangPerToko =
        dataMap.entries.map((entry) {
          final List<dynamic> itemsJson = entry.value;
          final List<Keranjang> items =
              itemsJson
                  .map((itemJson) => Keranjang.fromJson(itemJson))
                  .toList();
          return KeranjangToko(namaToko: entry.key, items: items);
        }).toList();

    return KeranjangResponse(
      data: keranjangPerToko,
      // DIUBAH: Menggunakan int.tryParse untuk konversi yang aman
      totalJumlah: int.tryParse(json['jumlah'].toString()) ?? 0,
    );
  }
}
