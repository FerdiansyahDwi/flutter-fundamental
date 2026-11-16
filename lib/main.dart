import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Secure Storage - Ferdi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Inisialisasi instance FlutterSecureStorage
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final String myKey = 'myPass';

  // Controller untuk menampung input dari TextField
  final TextEditingController pwdController = TextEditingController();

  // Variabel state untuk menampilkan hasil dekripsi
  String myPass = '';

  // Fungsi untuk menulis & mengenkripsi data ke Secure Storage
  Future<void> writeToSecureStorage() async {
    await storage.write(key: myKey, value: pwdController.text);
  }

  // Fungsi untuk membaca & mendekripsi data dari Secure Storage
  Future<String> readFromSecureStorage() async {
    String secret = await storage.read(key: myKey) ?? '';
    return secret;
  }

  @override
  void dispose() {
    pwdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Path Provider & Secure Storage - Ferdi'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: pwdController,
                obscureText: true, // Menyembunyikan karakter password (opsional)
                decoration: const InputDecoration(
                  labelText: 'Super Secret String',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  writeToSecureStorage().then((value) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Data berhasil disimpan secara aman!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  });
                },
                child: const Text('Save Value'),
              ),
              const SizedBox(height: 12),
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
              const SizedBox(height: 30),
              const Text(
                'Hasil Dekripsi dari Secure Storage:',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                myPass,
                style: const TextStyle(fontSize: 20, color: Colors.indigo),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}