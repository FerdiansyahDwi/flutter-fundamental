import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pml/model/pizza.dart';

/// Kelas helper untuk mengelola komunikasi jaringan (REST API) dengan WireMock.
/// Mengimplementasikan pola desain Singleton agar hanya ada satu instance HttpHelper di seluruh aplikasi.
class HttpHelper {
  // 1. Pola Singleton: Variabel privat statis untuk menyimpan satu-satunya instance
  static final HttpHelper _httpHelper = HttpHelper._internal();

  // 2. Named constructor privat agar tidak bisa diinstansiasi langsung dari luar kelas
  HttpHelper._internal();

  // 3. Factory constructor untuk mengembalikan instance singleton yang sudah ada
  factory HttpHelper() {
    return _httpHelper;
  }

  // 4. Konfigurasi Endpoint WireMock Cloud
  final String authority = '3z2wd1.wiremockapi.cloud';
  final String pathPizzaList = '/pizzalist';
  final String pathPizza = '/pizza';

  // ---------------------------------------------------------------------------
  // METHOD: GET /pizzalist
  // Mengambil daftar seluruh pizza dari Mock API WireMock
  // ---------------------------------------------------------------------------
  Future<List<Pizza>> getPizzaList() async {
    try {
      final Uri url = Uri.https(authority, pathPizzaList);
      final http.Response response = await http.get(url);

      // Pengecekan status code HTTP
      if (response.statusCode == 200) {
        // Status 200 OK: Response sukses diterima
        final dynamic jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          final List<Pizza> pizzas =
              jsonResponse.map<Pizza>((item) => Pizza.fromJson(item)).toList();
          return pizzas;
        }
        return [];
      } else if (response.statusCode == 404) {
        // Status 404 Not Found: Endpoint atau data tidak ditemukan
        debugPrint('GET /pizzalist Gagal: Data tidak ditemukan (Status 404)');
        return [];
      } else if (response.statusCode == 500) {
        // Status 500 Internal Server Error: Gangguan pada server WireMock
        debugPrint('GET /pizzalist Gagal: Kesalahan internal server (Status 500)');
        return [];
      } else {
        // Menangani status code lainnya
        debugPrint('GET /pizzalist Gagal dengan status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Menangani error koneksi jaringan atau parsing
      debugPrint('Exception saat getPizzaList: $e');
      return [];
    }
  }

  // ---------------------------------------------------------------------------
  // METHOD: POST /pizza
  // Menambahkan data pizza baru ke Mock API WireMock
  // ---------------------------------------------------------------------------
  Future<String> postPizza(Pizza pizza) async {
    try {
      final Uri url = Uri.https(authority, pathPizza);
      final String payload = json.encode(pizza.toJson());

      final http.Response response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      // Pengecekan status code (200 OK / 201 Created / 404 / 500)
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Status 201 Created atau 200 OK: Berhasil menambah data
        return response.body.isNotEmpty
            ? response.body
            : 'Berhasil: Pizza berhasil ditambahkan!';
      } else if (response.statusCode == 404) {
        return 'Gagal: Endpoint POST /pizza tidak ditemukan (Status 404).';
      } else if (response.statusCode == 500) {
        return 'Gagal: Terjadi kesalahan server saat menyimpan (Status 500).';
      } else {
        return 'Gagal menyimpan pizza (Status ${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      return 'Terjadi gangguan jaringan: $e';
    }
  }

  // ---------------------------------------------------------------------------
  // METHOD: PUT /pizza
  // Memperbarui data pizza yang sudah ada ke Mock API WireMock
  // ---------------------------------------------------------------------------
  Future<String> putPizza(Pizza pizza) async {
    try {
      final Uri url = Uri.https(authority, pathPizza);
      final String payload = json.encode(pizza.toJson());

      final http.Response response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      // Pengecekan status code (200 OK / 201 Created / 404 / 500)
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Status 200 OK: Berhasil memperbarui data
        return response.body.isNotEmpty
            ? response.body
            : 'Berhasil: Pizza berhasil diperbarui!';
      } else if (response.statusCode == 404) {
        return 'Gagal: Data pizza tidak ditemukan untuk diupdate (Status 404).';
      } else if (response.statusCode == 500) {
        return 'Gagal: Terjadi kesalahan server saat update (Status 500).';
      } else {
        return 'Gagal update pizza (Status ${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      return 'Terjadi gangguan jaringan: $e';
    }
  }

  // ---------------------------------------------------------------------------
  // METHOD: DELETE /pizza
  // Menghapus data pizza berdasarkan id di Mock API WireMock
  // ---------------------------------------------------------------------------
  Future<String> deletePizza(int id) async {
    try {
      final Uri url = Uri.https(authority, pathPizza);
      final String payload = json.encode({'id': id});

      final http.Response response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: payload,
      );

      // Pengecekan status code (200 OK / 204 No Content / 404 / 500)
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Status 200 OK: Berhasil menghapus data
        return response.body.isNotEmpty
            ? response.body
            : 'Berhasil: Pizza dengan ID $id berhasil dihapus!';
      } else if (response.statusCode == 404) {
        return 'Gagal: Data pizza ID $id tidak ditemukan (Status 404).';
      } else if (response.statusCode == 500) {
        return 'Gagal: Server mengalami gangguan saat menghapus pizza (Status 500).';
      } else {
        return 'Gagal menghapus pizza (Status ${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      return 'Terjadi gangguan jaringan: $e';
    }
  }
}
