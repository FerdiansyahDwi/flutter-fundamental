import 'package:flutter/material.dart';

class inputTextWidget extends StatelessWidget {
  const inputTextWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const TextField(
      obscureText: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Nama',
      ),
    );
  }
}