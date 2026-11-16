import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pml/basic_widgets/text_input.dart';
import 'package:pml/basic_widgets/text_widget.dart';
import 'package:pml/basic_widgets/image_widget.dart';
import 'package:pml/model/pizza.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  int _counter = 0;

  Future<int> getCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var appCounter = preferences.getInt('counter') ?? 0;

    setState(() {
      _counter = appCounter;
    });

    return appCounter;
  }

  Future<void> writeCounter() async {
    _counter++;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('counter', _counter);

    setState(() {});
  }

  void _onCounterAdd() {
    writeCounter();
  }

  void _onResetCounter() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('counter', 0);

    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Text("Counter click : $_counter"),
              ElevatedButton(
                onPressed: _onResetCounter,
                child: const Text("Reset Counter"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: _onCounterAdd),
    );
  }
}
