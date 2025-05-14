// lib/views/dokter/dokter_detail.dart

import 'package:flutter/material.dart';
import '../../models/dokter.dart';
import 'package:lenora/views/dokter/pembayaran.dart';

class DoctorDetailPage extends StatefulWidget {

  final Dokter dokter;

  const DoctorDetailPage({Key? key, required this.dokter}) : super(key: key);

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  int selectedTabIndex = 0;
  int selectedDateIndex = 0;
  int selectedTimeIndex = 0;

  final List<String> tabTitles = ['Jadwal', 'Review'];
  final List<String> dates = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
  final List<String> times = ['08:00', '10:00', '13:00', '15:00', '20:00'];

  void selectTab(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  void selectDate(int index) {
    setState(() {
      selectedDateIndex = index;
    });
  }

  void selectTime(int index) {
    setState(() {
      selectedTimeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dokter = widget.dokter;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF0F2D52)),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'DETAIL DOKTER',
          style: TextStyle(
            color: Color(0xFF0F2D52),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildDoctorProfileCard(context, dokter),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF0F2D52),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  _buildTabSelector(),
                  _buildScheduleSection(),
                  _buildConsultButton(context, dokter),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorProfileCard(BuildContext context, Dokter dokter) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0F2D52), width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                dokter.foto.isNotEmpty

                    ? 'http://192.168.18.9:8000/storage/${dokter.foto}'
                    : 'https://via.placeholder.com/300x400',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 60, color: Colors.grey);
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            dokter.namaDokter,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F2D52),
            ),
          ),
          Text(
            "Rp. ${dokter.hargaKonsultasi} ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 103, 103, 103),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildActionButton(Icons.favorite, Colors.pink),
              const SizedBox(width: 16),
              _buildActionButton(Icons.chat_bubble, Color(0xFF0F2D52)),
              const SizedBox(width: 16),
              _buildActionButton(Icons.share, Color(0xFF0F2D52)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2441),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(tabTitles.length, (index) {
          final selected = selectedTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => selectTab(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  tabTitles[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? const Color(0xFF0F2D52) : Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Agustus 2025',
              style: TextStyle(
                color: Color.fromARGB(161, 255, 255, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Senin - Sabtu, 08:00 - 23:59 WIB',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildHorizontalScroll(dates, selectedDateIndex, selectDate),
            const SizedBox(height: 40),
            const Text(
              'Jam Yang Tersedia',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mohon perhatikan nomor antrian dokter akan respon pada jam jam tersebut',
              style: TextStyle(
                color: Color.fromARGB(165, 255, 255, 255),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            _buildHorizontalScroll(times, selectedTimeIndex, selectTime),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHorizontalScroll(
    List<String> items,
    int selectedIndex,
    Function(int) onTap,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          items.length,
          (index) => GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              width: 70,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color:
                    selectedIndex == index ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                items[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color:
                      selectedIndex == index
                          ? const Color(0xFF0F2D52)
                          : const Color.fromARGB(161, 255, 255, 255),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConsultButton(BuildContext context, Dokter dokter) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BayarDokterPage(dokter: dokter),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0F2D52),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text(
          'KONSULTASI',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      )
    );
  }
}
