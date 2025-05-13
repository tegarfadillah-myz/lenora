// lib/models/dokter.dart

class Dokter {
  final int id;
  final String namaDokter;
  final int hargaKonsultasi;
  final int tahunPengalaman;
  final String kota;
  final int rating;
  final String spesialisasi;
  final String foto;
  final String deskripsi;
  final String emailDokter;
  final String nohpDokter;

  Dokter({
    required this.id,
    required this.namaDokter,
    required this.hargaKonsultasi,
    required this.tahunPengalaman,
    required this.kota,
    required this.rating,
    required this.spesialisasi,
    required this.foto,
    required this.deskripsi,
    required this.emailDokter,
    required this.nohpDokter,
  });
  factory Dokter.fromJson(Map<String, dynamic> json) {
    return Dokter(
      id: json['id'],
      namaDokter: json['nama_dokter'],
      hargaKonsultasi: json['harga_konsultasi'],
      tahunPengalaman: json['tahun_pengalaman'],
      kota: json['kota'],
      rating: json['rating'],
      spesialisasi: json['spesialisasi'],
      foto: json['foto'],
      deskripsi: json['deskripsi'],
      emailDokter: json['email_dokter'],
      nohpDokter: json['nohp_dokter'],
    );
  }
}
