import 'package:flutter/material.dart';
import 'pages/consult_doctors_page.dart';

void main() {
  runApp(const ConsultDoctorsApp());
}

class ConsultDoctorsApp extends StatelessWidget {
  const ConsultDoctorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Consult Doctors',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.purple,
      ),
      home: const ConsultDoctorsPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
