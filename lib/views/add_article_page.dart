// lib/pages/add_article_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'article_page.dart'; // Impor class Category

class AddArticlePage extends StatefulWidget {
  final List<Category> categories;

  const AddArticlePage({super.key, required this.categories});

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  String? _selectedCategoryId;
  String _selectedFeaturedStatus = 'featured';
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitArticle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://172.20.10.5:8000/api/artikel'),
      );

      request.fields['name'] = _titleController.text;
      request.fields['content'] = _contentController.text;
      request.fields['category_id'] = _selectedCategoryId!;
      request.fields['is_featured'] = _selectedFeaturedStatus;

      if (_imageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'thumbnail',
            _imageFile!.path,
          ),
        );
      }

      final response = await request.send();

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Artikel berhasil dibuat!'),
              backgroundColor: Colors.green,
            ),
          );
          // Kirim 'true' untuk menandakan sukses
          Navigator.pop(context, true);
        }
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception(
            'Gagal menyimpan artikel. Status: ${response.statusCode}, Body: $responseBody');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Artikel Baru'),
        backgroundColor: const Color(0xFF0F2D52),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul Artikel
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul Artikel',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Kategori
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('-- Pilih Kategori --'),
                items: widget.categories.map((Category category) {
                  return DropdownMenuItem<String>(
                    value: category.id.toString(),
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategoryId = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              // Konten Artikel
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Konten Artikel',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 6,
                validator: (value) => value == null || value.isEmpty
                    ? 'Konten wajib diisi'
                    : null,
              ),
              const SizedBox(height: 24),

              // Thumbnail
              Text('Thumbnail', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(_imageFile!, fit: BoxFit.cover),
                      )
                    : const Center(child: Text('Belum ada gambar dipilih')),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pilih Gambar'),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 16),

              // Featured Status
              DropdownButtonFormField<String>(
                value: _selectedFeaturedStatus,
                decoration: const InputDecoration(
                  labelText: 'Tampilkan di Beranda',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'featured', child: Text('Tampilkan')),
                  DropdownMenuItem(
                      value: 'not_featured', child: Text('Tidak Tampilkan')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFeaturedStatus = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              ElevatedButton(
                onPressed: _isLoading ? null : _submitArticle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F2D52),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text('Simpan Artikel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}