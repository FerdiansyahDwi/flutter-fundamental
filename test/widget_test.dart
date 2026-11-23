import 'package:flutter_test/flutter_test.dart';
import 'package:pml/model/pizza.dart';
import 'package:pml/api/pizza.dart';

void main() {
  group('Pizza Model Tests', () {
    test('Pizza.fromJson parses correctly with valid data', () {
      final json = {
        'id': 1,
        'pizzaName': 'Margherita',
        'description': 'Delicious cheese pizza',
        'price': 8.75,
        'imageUrl': 'assets/pizza.jpg',
        'category': 'classic',
      };

      final pizza = Pizza.fromJson(json);

      expect(pizza.id, 1);
      expect(pizza.pizzaName, 'Margherita');
      expect(pizza.description, 'Delicious cheese pizza');
      expect(pizza.price, 8.75);
      expect(pizza.imageUrl, 'assets/pizza.jpg');
      expect(pizza.category, 'classic');
    });

    test('Pizza.fromJson is null-safe and handles missing fields', () {
      final json = <String, dynamic>{};

      final pizza = Pizza.fromJson(json);

      expect(pizza.id, 0);
      expect(pizza.pizzaName, 'Tanpa Nama');
      expect(pizza.description, '');
      expect(pizza.price, 0.0);
      expect(pizza.imageUrl, '');
    });

    test('Pizza.toJson serializes properly', () {
      final pizza = Pizza(
        id: 2,
        pizzaName: 'Pepperoni',
        description: 'Spicy pepperoni',
        price: 10.5,
        imageUrl: 'assets/pizza.jpg',
        category: 'classic',
      );

      final map = pizza.toJson();

      expect(map['id'], 2);
      expect(map['pizzaName'], 'Pepperoni');
      expect(map['price'], 10.5);
    });
  });

  group('HttpHelper Singleton Tests', () {
    test('HttpHelper factory constructor returns singleton instance', () {
      final helper1 = HttpHelper();
      final helper2 = HttpHelper();

      expect(identical(helper1, helper2), isTrue);
    });
  });
}
