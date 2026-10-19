import 'package:flutter/material.dart';
import 'package:pml/domain/barang.dart';

class DetailShopingScreen extends StatelessWidget {
  const DetailShopingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final barang = 
        ModalRoute.of(context)!.settings.arguments as Barang;
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