import 'package:flutter/material.dart';
import 'package:pml/basic_widgets/text_input.dart';
import 'package:pml/basic_widgets/text_widget.dart';
import 'package:pml/basic_widgets/image_widget.dart';

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
  DateTime? _dateTime = DateTime.now();

  // void _incrementCounter() {
  //   setState(() {
  //     _counter++;
  //   });
  // }

  void tampilkanDialog(BuildContext context) {
    Widget okButton =  TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.pop(context),
    );

    AlertDialog dialog = AlertDialog(
      title: Text("Judul Dialog"),
      content: Text("ini isi dialog Ferdi"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: .center,
          children: [
            Text(_dateTime?.toIso8601String() ?? "Test"),

            MyImageWidget(),
            const MyTextWidget(),

            inputTextWidget(),

            ElevatedButton(
              child: Text("Ubah tanggal"),
              onPressed: () async {
                final DateTime? tanggal = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2100),
                );

                if (tanggal != null && tanggal != _dateTime) {
                  setState(() {
                    _dateTime = tanggal;
                  });
                }
              }
            ),

            // const Text('You have pushed the button this many times:'),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tampilkanDialog(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
