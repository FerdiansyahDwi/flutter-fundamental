class Pizza {
  final int id;
  final String pizzaName;
  final String description;
  final double price;
  final String imageUrl;

  Pizza({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  Pizza.fromJson(Map<String, dynamic> dataStore)
    : id = dataStore["id"] ?? 0,
      pizzaName = dataStore["pizzaName"] ?? "",
      description = dataStore["description"] ?? "",
      price = dataStore["price"] ?? 0.0,
      imageUrl = dataStore["imageUrl"] ?? "";
}
