import 'package:flutter/material.dart';

class MyTextWidget extends StatelessWidget {
  const MyTextWidget({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Nama Saya Ferdi, Saya sedang belajar flutter",
      style: TextStyle(
        color: Colors.red,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    );
  }
}