import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
// Trong VS Code: Mở Command Palette (Ctrl + Shift + P) > gõ Dart: Change SDK và đảm bảo nó trỏ đến đường dẫn của Dart SDK 3.5.4.