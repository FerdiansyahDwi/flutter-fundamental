import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pml/basic_widgets/text_input.dart';
import 'package:pml/basic_widgets/text_widget.dart';
import 'package:pml/basic_widgets/image_widget.dart';
import 'package:pml/model/pizza.dart';

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
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Pizza> dataPizza = [];

  Future readJsonFile() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/pizzalist.json');

    try {
      var data = jsonDecode(jsonString) as List<dynamic>;
      var listPizza = data.map((e) => Pizza.fromJson(e)).toList();

      print("nama : ${listPizza[0]?.pizzaName}");
      setState(() {
        dataPizza = listPizza;
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    readJsonFile();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: dataPizza.length,
          itemBuilder:  (context, index) {
            return ListTile(
              title: Text(dataPizza[index].pizzaName),
              subtitle: Text(dataPizza[index].description),
            );
          },
        ),
      )
    );
  }
}
