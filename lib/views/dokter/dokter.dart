import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lenora/views/dokter/DokterDetail.dart';
import 'package:lenora/widgets/bottomnavbar.dart';
import 'package:lenora/models/dokter.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class DoctorCard extends StatelessWidget {
  final Dokter dokter;
  final VoidCallback onTap;

  const DoctorCard({super.key, required this.dokter, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Container(
                height: 140,
                width: double.infinity,
                child: Image.network(
                  dokter.foto.isNotEmpty
                      ? 'http://127.0.0.1:8000/storage/${dokter.foto}'
                      : 'https://via.placeholder.com/300x400',
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    return Container(
                      color: Colors.grey[300],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person, color: Colors.grey, size: 40),
                          SizedBox(height: 4),
                          Text(
                            'Photo not available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dokter.namaDokter,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        'Rp ${dokter.hargaKonsultasi}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 4),
                  Text(
                    dokter.spesialisasi,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  // const SizedBox(height: 4),
                  Text(
                    dokter.kota,
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        dokter.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DoctorPageState extends State<DoctorPage> {
  List<Dokter> doctors = [];
  List<String> specialties = [];
  String? errorMessage;
  String? selectedSpecialty;

  @override
  void initState() {
    super.initState();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      final response = await http.get(

        Uri.parse('http://192.168.18.14:8000/api/dokter'),

      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['data'];

        setState(() {
          doctors = data.map((json) => Dokter.fromJson(json)).toList();
          // Extract unique specialties from doctors
          specialties =
              doctors.map((doctor) => doctor.spesialisasi).toSet().toList();
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage =
              'Failed to load doctors. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
      print('Exception caught: $e');
    }
  }

  void _navigateToDetail(Dokter dokter) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DoctorDetailPage(dokter: dokter)),
    );
  }

  void _filterBySpecialty(String? specialty) {
    setState(() {
      selectedSpecialty = specialty;
    });
  }

  List<Dokter> get filteredDoctors {
    if (selectedSpecialty == null) {
      return doctors;
    }
    return doctors
        .where((doctor) => doctor.spesialisasi == selectedSpecialty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the height of the custom app bar
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight =
        statusBarHeight + 48; // Adjusted based on your header height

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Main content - pushed down to make room for the header
          Positioned(
            top: appBarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false, // Since we're handling the top padding manually
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Dokter Spesialis',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Filter Button
                    Container(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          FilterChip(
                            label: Text('Semua'),
                            selected: selectedSpecialty == null,
                            onSelected: (_) => _filterBySpecialty(null),
                            backgroundColor: Colors.grey[200],
                            selectedColor: Colors.blue[100],
                            labelStyle: TextStyle(
                              color:
                                  selectedSpecialty == null
                                      ? Colors.blue
                                      : Colors.black87,
                              fontWeight:
                                  selectedSpecialty == null
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ...specialties
                              .map(
                                (specialty) => Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: FilterChip(
                                    label: Text(specialty),
                                    selected: selectedSpecialty == specialty,
                                    onSelected:
                                        (_) => _filterBySpecialty(specialty),
                                    backgroundColor: Colors.grey[200],
                                    selectedColor: Colors.blue[100],
                                    labelStyle: TextStyle(
                                      color:
                                          selectedSpecialty == specialty
                                              ? Colors.blue
                                              : Colors.black87,
                                      fontWeight:
                                          selectedSpecialty == specialty
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child:
                          doctors.isEmpty
                              ? Center(
                                child:
                                    errorMessage != null
                                        ? Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Text(
                                            errorMessage!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                        : const CircularProgressIndicator(),
                              )
                              : GridView.builder(
                                itemCount: filteredDoctors.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 0.7,
                                    ),
                                itemBuilder: (context, index) {
                                  final dokter = filteredDoctors[index];
                                  return DoctorCard(
                                    dokter: dokter,
                                    onTap: () => _navigateToDetail(dokter),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Custom header that spans the full width
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: const Color(0xFF0F2D52),
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 10,
                bottom: 10,
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/Desain tanpa judul.png',
                        width: 28,
                        height: 28,
                        errorBuilder: (_, __, ___) {
                          return const CircleAvatar(
                            backgroundColor: Color(0xFF0F2D52),
                            child: Text(
                              'S',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'SKINEXPERT',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.chat_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Arahkan ke halaman keranjang
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Arahkan ke halaman keranjang
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Arahkan ke halaman profil
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }
}
