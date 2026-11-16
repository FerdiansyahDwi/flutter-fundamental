// ============================================================================
// Unit Test: Pengujian Model Pizza, Parsing Aman, dan Broken JSON
// Memverifikasi Checklist 1, 2, dan 5
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:pml/model/pizza.dart';

void main() {
  group('Pizza Model Safe Parsing Tests', () {
    test('Checklist 1 & 2: Parsing normal dengan konstanta kunci', () {
      final Map<String, dynamic> normalJson = {
        keyId: 1,
        keyPizzaName: 'Margherita',
        keyDescription: 'Delicious classic cheese pizza',
        keyPrice: 12.5,
        keyImageUrl: 'assets/pizza.jpg',
      };

      final pizza = Pizza.fromJson(normalJson);

      expect(pizza.id, equals(1));
      expect(pizza.pizzaName, equals('Margherita'));
      expect(pizza.description, equals('Delicious classic cheese pizza'));
      expect(pizza.price, equals(12.5));
      expect(pizza.imageUrl, equals('assets/pizza.jpg'));

      // Uji toJson serialization
      final Map<String, dynamic> jsonOut = pizza.toJson();
      expect(jsonOut[keyId], equals(1));
      expect(jsonOut[keyPizzaName], equals('Margherita'));
      expect(jsonOut[keyPrice], equals(12.5));
    });

    test('Checklist 1 & 5: Broken JSON / Tipe Data Campuran (Tidak Crash)', () {
      final Map<String, dynamic> brokenJson = {
        keyId: 'bukan_angka_id', // String bukan int
        keyPizzaName: null, // null string
        keyDescription: '   ', // string spasi kosong
        keyPrice: 'harga_rusak_bukan_double', // string bukan double
        keyImageUrl: null,
      };

      // Harus di-parse tanpa crash / throw exception!
      final pizza = Pizza.fromJson(brokenJson);

      // Verifikasi nilai fallback ramah
      expect(pizza.id, equals(defaultPizzaId)); // 0
      expect(pizza.pizzaName, equals(defaultPizzaName)); // Nama default ramah
      expect(pizza.description, equals(defaultDescription)); // Deskripsi default
      expect(pizza.price, equals(defaultPrice)); // 0.0
      expect(pizza.imageUrl, equals(defaultImageUrl)); // 'assets/pizza.jpg'
    });

    test('Checklist 1: Parsing angka dalam bentuk String secara aman (tryParse)', () {
      final Map<String, dynamic> stringNumberJson = {
        keyId: '99',
        keyPizzaName: 'Pepperoni Supreme',
        keyDescription: 'Extra cheese and beef',
        keyPrice: '15.75',
        keyImageUrl: 'assets/pizza.jpg',
      };

      final pizza = Pizza.fromJson(stringNumberJson);

      expect(pizza.id, equals(99));
      expect(pizza.price, equals(15.75));
    });
  });
}
