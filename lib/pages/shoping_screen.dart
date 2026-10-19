import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pml/data/barang.dart';

class ShopingScreen extends StatelessWidget {
  const ShopingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shoping List'),
        backgroundColor: const Color.fromARGB(255, 33, 217, 241),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: list_barang.length,
          itemBuilder: (context, index) {
            final barang = list_barang[index];
            return GestureDetector(
              onTap: () {
                context.go('/detail/${barang.id}');
              },
              child: Container(
                color: const Color.fromARGB(255, 165, 228, 238),
                margin: const EdgeInsets.symmetric(vertical: 3),
                padding: const EdgeInsets.all(5),
                child: Text(barang.nama_barang),
              ),
            );
          },
        ),
      ),
    );
  }
}
