import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Secure Storage - Dido',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const MyHomePage(title: 'Secure Storage - Dido'),
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
  final storage = const FlutterSecureStorage();
  final myKey = 'myPass';
  final pwdController = TextEditingController();
  String myPass = '';

  Future<void> writeToSecureStorage() async {
    await storage.write(key: myKey, value: pwdController.text);
  }

  Future<String> readFromSecureStorage() async {
    String secret = await storage.read(key: myKey) ?? '';
    return secret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: pwdController,
              decoration: const InputDecoration(labelText: 'Masukkan password'),
            ),
            ElevatedButton(
              onPressed: () {
                writeToSecureStorage();
              },
              child: const Text('Save Value'),
            ),
            ElevatedButton(
              onPressed: () {
                readFromSecureStorage().then((value) {
                  setState(() {
                    myPass = value;
                  });
                });
              },
              child: const Text('Read Value'),
            ),
            Text(myPass),
          ],
        ),
      ),
    );
  }
}