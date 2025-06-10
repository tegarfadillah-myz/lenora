import 'package:flutter/material.dart';
import 'package:lenora/services/auth_service.dart';
import 'package:lenora/views/auth/login_page.dart';
import 'package:lenora/views/beranda/HomePage.dart';
import 'package:lenora/splash.dart';
import 'package:provider/provider.dart';

void main() {
  // 1. Tambahkan ChangeNotifierProvider di sini
  // Ini membuat AuthService tersedia untuk seluruh aplikasi
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Mempertahankan semua tema dan properti Anda
    return MaterialApp(
      title: 'Consult Doctors',
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.blue),
      // 2. Arahkan SplashScreen ke AuthCheck setelah selesai
      // AuthCheck akan menjadi "gerbang" pengecekan login
      home: SplashScreen(nextScreen: const AuthCheck()),
      debugShowCheckedModeBanner: false,
    );
  }
}

// 3. Buat Widget baru untuk Pengecekan Otentikasi
// Widget ini akan menjadi tujuan setelah SplashScreen
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil instance AuthService yang sudah kita sediakan di main()
    final authService = Provider.of<AuthService>(context, listen: false);

    // Gunakan FutureBuilder untuk mencoba login otomatis
    return FutureBuilder(
      // Menjalankan fungsi yang memeriksa token di SharedPreferences
      future: authService.tryAutoLogin(),
      builder: (context, authResultSnapshot) {
        // Selama proses pengecekan, tampilkan loading spinner
        // Ini biasanya sangat cepat dan mungkin tidak terlihat oleh pengguna
        if (authResultSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Setelah pengecekan selesai, gunakan Consumer untuk mendengarkan status login
        return Consumer<AuthService>(
          builder: (context, auth, _) {
            // Jika terotentikasi (berhasil auto-login atau login sebelumnya)
            if (auth.isAuthenticated) {
              // Arahkan ke halaman utama Anda
              return HomePage();
            } else {
              // Jika tidak, arahkan ke halaman login
              return const LoginPage();
            }
          },
        );
      },
    );
  }
}

// Widget MyHomePage tidak lagi digunakan, bisa dihapus jika mau
// class MyHomePage extends StatelessWidget { ... }
