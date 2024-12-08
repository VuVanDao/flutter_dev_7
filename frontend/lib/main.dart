import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Ung dung web don gian",
        home: Center(
          child: MyHomePage(),
        ));
  }
}

// Trong VS Code: Mở Command Palette (Ctrl + Shift + P) > gõ Dart: Change SDK và đảm bảo nó trỏ đến đường dẫn của Dart SDK 3.5.4.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _headers = {'Content-Type': "application/json"};
  //controller de lay du lieu tub textField
  final controller = TextEditingController();
  final diem = TextEditingController();
  //bien de luu thong diep phan hoi tu server
  String responseMessage = '';
  Future<void> sendName() async {
    final name = controller.text;
    final score = diem.text;
    controller.clear();
    diem.clear();
    final url = Uri.parse("http://localhost:8080/api/v1/submit");
    try {
      final response = await http
          .post(url,
              headers: {'Content-Type': 'application/json'},
              body: json.encode({'name': name, 'diem': score}))
          .timeout(const Duration(seconds: 10));
      if (response.body.isNotEmpty) {
        final data = json.decode(response.body);

        setState(() {
          responseMessage = data['message'];
        });
      } else {
        setState(() {
          responseMessage = "khong nhan duoc phan hoi";
        });
      }
    } catch (e) {
      setState(() {
        responseMessage = "Da xay ra loi ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("hehe"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: "Ten"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: diem,
              decoration: const InputDecoration(labelText: "Diem"),
            ),
            const SizedBox(
              height: 50,
            ),
            FilledButton(onPressed: sendName, child: const Text("Submit")),
            const SizedBox(
              height: 50,
            ),
            Text(
              responseMessage,
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }
}
