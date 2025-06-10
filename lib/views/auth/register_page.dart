// // lib/views/auth/register_page.dart

// import 'package:flutter/material.dart';
// import 'package:lenora/services/auth_service.dart';
// import 'package:lenora/views/auth/login_page.dart';
// import 'package:provider/provider.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _nohpController = TextEditingController();
//   bool _isLoading = false;

//   void _register() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => _isLoading = true);
//       try {
//         await Provider.of<AuthService>(context, listen: false).register(
//           name: _nameController.text,
//           email: _emailController.text,
//           password: _passwordController.text,
//           nohp: _nohpController.text,
//         );
//         // Navigasi akan ditangani oleh Consumer di main.dart
//       } catch (e) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
//       } finally {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const Icon(
//                   Icons.person_add_alt_1,
//                   size: 80,
//                   color: Color(0xFF0F2D52),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Buat Akun Baru',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 40),
//                 TextFormField(
//                   controller: _nameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Nama Lengkap',
//                     border: OutlineInputBorder(),
//                   ),
//                   validator:
//                       (value) =>
//                           (value == null || value.isEmpty)
//                               ? 'Nama tidak boleh kosong'
//                               : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator:
//                       (value) =>
//                           (value == null || !value.contains('@'))
//                               ? 'Email tidak valid'
//                               : null,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _nohpController,
//                   decoration: const InputDecoration(
//                     labelText: 'No. Handphone (Opsional)',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.phone,
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   obscureText: true,
//                   validator:
//                       (value) =>
//                           (value == null || value.length < 6)
//                               ? 'Password minimal 6 karakter'
//                               : null,
//                 ),
//                 const SizedBox(height: 24),
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ElevatedButton(
//                       onPressed: _register,
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         backgroundColor: const Color(0xFF0F2D52),
//                       ),
//                       child: const Text('Daftar'),
//                     ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text("Sudah punya akun?"),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const LoginPage(),
//                           ),
//                         );
//                       },
//                       child: const Text('Login di sini'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
