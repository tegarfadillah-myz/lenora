import 'package:flutter/material.dart';
import 'screens/article_page.dart'; // ✅ import screen baru

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artikel Kesehatan',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: const ArticlePage(), // ✅ gunakan screen dari folder
      debugShowCheckedModeBanner: false,
    );
  }
}
