import 'package:flutter/material.dart';
import 'package:pml/pages/detail_shoping_screen.dart';
import 'package:pml/pages/shoping_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => ShopingScreen(), 
        '/detail' : (context) => DetailShopingScreen(),
      },
    );
  }
}
