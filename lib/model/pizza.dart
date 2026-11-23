// Konstanta kunci JSON untuk mencegah kesalahan pengetikan (typo) pada key JSON
const String keyId = 'id';
const String keyPizzaName = 'pizzaName';
const String keyDescription = 'description';
const String keyPrice = 'price';
const String keyImageUrl = 'imageUrl';
const String keyCategory = 'category';

/// Model class Pizza untuk merepresentasikan data pizza dari Mock API WireMock.
/// Seluruh atribut didesain aman dari nilai null dengan nilai default yang sesuai.
class Pizza {
  // 1. Atribut-atribut Pizza
  final int id;
  final String pizzaName;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  // 2. Konstruktor utama dengan default parameter untuk mencegah null
  Pizza({
    this.id = 0,
    this.pizzaName = '',
    this.description = '',
    this.price = 0.0,
    this.imageUrl = '',
    this.category = '',
  });

  // 3. Konstruktor fromJson yang aman dari null menggunakan int.tryParse dan double.tryParse
  // Jika format data tidak sesuai atau bernilai null, maka fallback ke nilai default
  Pizza.fromJson(Map<String, dynamic> json)
      : id = int.tryParse(json[keyId]?.toString() ?? '') ?? 0,
        pizzaName = json[keyPizzaName]?.toString() ?? 'Tanpa Nama',
        description = json[keyDescription]?.toString() ?? '',
        price = double.tryParse(json[keyPrice]?.toString() ?? '') ?? 0.0,
        imageUrl = json[keyImageUrl]?.toString() ?? '',
        category = json[keyCategory]?.toString() ?? '';

  // 4. Metode toJson untuk mengonversi instance Pizza menjadi Map/JSON
  // Digunakan saat melakukan request POST dan PUT ke Mock API
  Map<String, dynamic> toJson() {
    return {
      keyId: id,
      keyPizzaName: pizzaName,
      keyDescription: description,
      keyPrice: price,
      keyImageUrl: imageUrl,
      if (category.isNotEmpty) keyCategory: category,
    };
  }
}
