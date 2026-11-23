import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:pml/model/pizza.dart';

class HttpHelper {
  // 1. Pola Singleton (Praktikum 1 - Slide 12)
  static final HttpHelper _httpHelper = HttpHelper._internal();
  HttpHelper._internal();
  factory HttpHelper() {
    return _httpHelper;
  }

  // 2. Alamat WireMock Cloud
  final String authority = '3z2wd1.wiremockapi.cloud';
  final String path = 'pizzalist';

  // PRAKTIKUM 1: GET Daftar Pizza
  Future<List<Pizza>> getPizzaList() async {
    final Uri url = Uri.https(authority, path);
    final http.Response result = await http.get(url);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List<Pizza> pizzas = jsonResponse
          .map<Pizza>((i) => Pizza.fromJson(i))
          .toList();
      return pizzas;
    } else {
      return [];
    }
  }

  // PRAKTIKUM 2: POST Data Pizza Baru
  Future<String> postPizza(Pizza pizza) async {
    const postPath = '/pizza';
    String post = json.encode(pizza.toJson());
    Uri url = Uri.https(authority, postPath);
    http.Response r = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: post,
    );
    return r.body;
  }

  // PRAKTIKUM 3: PUT Update Data Pizza
  Future<String> putPizza(Pizza pizza) async {
    const putPath = '/pizza';
    String put = json.encode(pizza.toJson());
    Uri url = Uri.https(authority, putPath);
    http.Response r = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: put,
    );
    return r.body;
  }

  // PRAKTIKUM 4: DELETE Hapus Data Pizza
  Future<String> deletePizza(int id) async {
    const deletePath = '/pizza';
    Uri url = Uri.https(authority, deletePath);
    http.Response r = await http.delete(url);
    return r.body;
  }
}
