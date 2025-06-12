// lib/views/auth/register_page.dart

import 'package:flutter/material.dart';
import 'package:lenora/services/auth_service.dart';
import 'package:lenora/views/auth/login_page.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // Mengganti nameController menjadi firstName dan lastName
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nohpController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    // Pastikan untuk melepaskan semua controller
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nohpController.dispose();
    super.dispose();
  }

  void _register() async {
    // Validasi form sebelum mengirim data
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        // Panggil service register dengan data yang sudah disesuaikan
        // Anda juga perlu memperbarui method `register` di AuthService
        await Provider.of<AuthService>(context, listen: false).register(
          name: _firstNameController.text,
          namaBelakang: _lastNameController.text, // Menambahkan nama belakang
          email: _emailController.text,
          password: _passwordController.text,
          nohp: _nohpController.text,
        );
        // Jika berhasil, navigasi akan ditangani oleh listener di main.dart
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registrasi Gagal: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.person_add_alt_1,
                  size: 80,
                  color: Color(0xFF0F2D52),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Buat Akun Baru',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                // Input untuk Nama Depan
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Depan', // Diubah dari Nama Lengkap
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Nama depan tidak boleh kosong'
                              : null,
                ),
                const SizedBox(height: 16),
                // Input baru untuk Nama Belakang
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Belakang',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Nama belakang tidak boleh kosong'
                              : null,
                ),
                const SizedBox(height: 16),
                // Input untuk Email
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator:
                      (value) =>
                          (value == null || !value.contains('@'))
                              ? 'Email tidak valid'
                              : null,
                ),
                const SizedBox(height: 16),
                // Input untuk No. Handphone
                TextFormField(
                  controller: _nohpController,
                  decoration: const InputDecoration(
                    labelText: 'No. Handphone (Opsional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                // Input untuk Password
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator:
                      (value) =>
                          (value == null || value.length < 6)
                              ? 'Password minimal 6 karakter'
                              : null,
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF0F2D52),
                        foregroundColor: Colors.white, // Warna teks tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Daftar'),
                    ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Sudah punya akun?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text('Login di sini'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
