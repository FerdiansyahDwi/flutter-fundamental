class Barang {
  final int id;
  // ignore: non_constant_identifier_names
  final String nama_barang;
  final String foto;
  final int stok;
  final double rating;
  final int reviewCount;
  final int harga;
  final int? hargaCoret;
  final String kategori;
  final String deskripsi;
  final int terjual;
  final String toko;
  final String kota;
  final String berat;
  final bool isFavorite;

  const Barang({
    required this.id,
    // ignore: non_constant_identifier_names
    required this.nama_barang,
    required this.foto,
    required this.stok,
    required this.rating,
    required this.reviewCount,
    required this.harga,
    this.hargaCoret,
    required this.kategori,
    required this.deskripsi,
    required this.terjual,
    this.toko = 'STIMATA Mart Official',
    this.kota = 'Kota Malang',
    this.berat = '1 kg',
    this.isFavorite = false,
  });

  // Getter alias untuk fleksibilitas kode
  String get nama => nama_barang;

  Barang copyWith({
    int? id,
    // ignore: non_constant_identifier_names
    String? nama_barang,
    String? foto,
    int? stok,
    double? rating,
    int? reviewCount,
    int? harga,
    int? hargaCoret,
    String? kategori,
    String? deskripsi,
    int? terjual,
    String? toko,
    String? kota,
    String? berat,
    bool? isFavorite,
  }) {
    return Barang(
      id: id ?? this.id,
      nama_barang: nama_barang ?? this.nama_barang,
      foto: foto ?? this.foto,
      stok: stok ?? this.stok,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      harga: harga ?? this.harga,
      hargaCoret: hargaCoret ?? this.hargaCoret,
      kategori: kategori ?? this.kategori,
      deskripsi: deskripsi ?? this.deskripsi,
      terjual: terjual ?? this.terjual,
      toko: toko ?? this.toko,
      kota: kota ?? this.kota,
      berat: berat ?? this.berat,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}