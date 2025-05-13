import 'package:flutter/material.dart';

// import 'package:lenora/views/article_page.dart';
// import 'package:lenora/views/article_detail_page.dart';
// import 'package:lenora/views/dokter/DokterDetail.dart';
// import 'package:lenora/views/beranda/Home.dart';
import 'package:lenora/views/beranda/HomePage.dart';
import 'package:lenora/splash.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consult Doctors',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.purple,
      ),
      home: SplashScreen(nextScreen: HomePage()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
