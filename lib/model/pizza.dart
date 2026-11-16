// ============================================================================
// File: lib/model/pizza.dart
// Deskripsi: Data Model Pizza dengan konstanta kunci JSON & parsing aman.
// ============================================================================

/// Konstanta kunci JSON (Checklist 2: Menggunakan konstanta kunci, bukan string literal)
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';
const String keyDescription = 'description';
const String keyPrice = 'price';
const String keyImageUrl = 'imageUrl';

/// Nilai fallback default ramah jika data JSON korup / hilang (Checklist 5: Nilai pengganti ramah)
const int defaultPizzaId = 0;
const String defaultPizzaName = 'Pizza Pilihan Chef (Nama Default)';
const String defaultDescription = 'Deskripsi pizza belum tersedia.';
const double defaultPrice = 0.0;
const String defaultImageUrl = 'assets/pizza.jpg';

/// Model data Pizza
class Pizza {
  final int id;
  final String pizzaName;
  final String description;
  final double price;
  final String imageUrl;

  const Pizza({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  /// Factory constructor untuk parsing JSON secara aman (Safe Parsing).
  /// 
  /// Sesuai Checklist 1 & Checklist 5:
  /// - Menggunakan int.tryParse dan double.tryParse disertai operator null-coalescing (??).
  /// - Menghindari cast langsung seperti `as int` atau `as double` agar tidak memicu TypeError.
  /// - Mengisi nilai pengganti yang ramah (fallback) jika menemukan nilai null/kosong/rusak.
  factory Pizza.fromJson(Map<String, dynamic> json) {
    // 1. Parsing ID secara aman (tryParse + ??)
    final dynamic rawId = json[keyId];
    int parsedId = defaultPizzaId;
    if (rawId is int) {
      parsedId = rawId;
    } else if (rawId != null) {
      parsedId = int.tryParse(rawId.toString()) ?? defaultPizzaId;
    }

    // 2. Parsing Nama Pizza secara aman (?? dan fallback string ramah)
    final dynamic rawName = json[keyPizzaName];
    final String parsedName =
        (rawName != null && rawName.toString().trim().isNotEmpty)
            ? rawName.toString().trim()
            : defaultPizzaName;

    // 3. Parsing Deskripsi secara aman
    final dynamic rawDesc = json[keyDescription];
    final String parsedDesc =
        (rawDesc != null && rawDesc.toString().trim().isNotEmpty)
            ? rawDesc.toString().trim()
            : defaultDescription;

    // 4. Parsing Harga secara aman (tryParse + ??)
    final dynamic rawPrice = json[keyPrice];
    double parsedPrice = defaultPrice;
    if (rawPrice is num) {
      parsedPrice = rawPrice.toDouble();
    } else if (rawPrice != null) {
      parsedPrice = double.tryParse(rawPrice.toString()) ?? defaultPrice;
    }
    // Jika harga bernilai negatif karena anomali data, berikan nilai default
    if (parsedPrice < 0) {
      parsedPrice = defaultPrice;
    }

    // 5. Parsing Gambar secara aman
    final dynamic rawImage = json[keyImageUrl];
    final String parsedImage =
        (rawImage != null && rawImage.toString().trim().isNotEmpty)
            ? rawImage.toString().trim()
            : defaultImageUrl;

    return Pizza(
      id: parsedId,
      pizzaName: parsedName,
      description: parsedDesc,
      price: parsedPrice,
      imageUrl: parsedImage,
    );
  }

  /// Mengonversi objek Pizza menjadi `Map<String, dynamic>` untuk serialisasi JSON.
  /// Menggunakan konstanta kunci JSON yang telah didefinisikan.
  Map<String, dynamic> toJson() {
    return {
      keyId: id,
      keyPizzaName: pizzaName,
      keyDescription: description,
      keyPrice: price,
      keyImageUrl: imageUrl,
    };
  }

  /// Helper untuk menduplikasi objek Pizza dengan modifikasi atribut tertentu
  Pizza copyWith({
    int? id,
    String? pizzaName,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Pizza(
      id: id ?? this.id,
      pizzaName: pizzaName ?? this.pizzaName,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  String toString() {
    return 'Pizza(id: $id, pizzaName: "$pizzaName", price: \$$price)';
  }
}
