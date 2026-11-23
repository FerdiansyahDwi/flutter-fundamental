import 'dart:convert';

const keyId = 'id';
const keyName = 'pizzaName';
const keyDescription = 'description';
const keyPrice = 'price';
const keyImage = 'imageUrl';
const keyCategory = 'category';

class Pizza {
  int id;
  String pizzaName;
  String description;
  double price;
  String imageUrl;
  String category;

  Pizza({
    this.id = 0,
    this.pizzaName = '',
    this.description = '',
    this.price = 0.0,
    this.imageUrl = '',
    this.category = '',
  });

  Pizza.fromJson(Map<String, dynamic> json)
      : id = int.tryParse(json[keyId].toString()) ?? 0,
        pizzaName = json[keyName] != null
            ? json[keyName].toString()
            : 'No name',
        description = json[keyDescription] != null
            ? json[keyDescription].toString()
            : '',
        price = double.tryParse(json[keyPrice].toString()) ?? 0.0,
        imageUrl = json[keyImage]?.toString() ?? '',
        category = json[keyCategory]?.toString() ?? '';

  Map<String, dynamic> toJson() {
    return {
      keyId: id,
      keyName: pizzaName,
      keyDescription: description,
      keyPrice: price,
      keyImage: imageUrl,
      keyCategory: category,
    };
  }
}