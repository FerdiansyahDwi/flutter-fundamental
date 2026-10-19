import 'package:flutter/material.dart';
import 'package:pml/data/barang.dart';
import 'package:pml/domain/barang.dart';

class DetailShopingScreen extends StatelessWidget {
  final String id;
  const DetailShopingScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final barang = list_barang.firstWhere(
      (barang) => barang.id.toString() == id,
    );
        
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Shoping'),
        backgroundColor: const Color.fromARGB(255, 33, 217, 241),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Text(barang.nama_barang),
      ),
    );
  }
}