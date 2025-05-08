import 'package:flutter/material.dart';
import '../widgets/doctor_card.dart';
import '../widgets/category_item.dart';
import '../widgets/custom_banner.dart';

class ConsultDoctorsPage extends StatelessWidget {
  const ConsultDoctorsPage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'icon': Icons.psychology, 'label': 'Brain'},
    {'icon': Icons.health_and_safety, 'label': 'Kidney'},
    {'icon': Icons.remove_red_eye, 'label': 'Eye'},
    {'icon': Icons.hearing, 'label': 'Ear'},
  ];

  final List<Map<String, dynamic>> doctors = const [
    {
      'name': 'Dr. Sneha Nu',
      'specialty': 'Cardiologist',
      'rating': 4.8,
      'image': 'https://via.placeholder.com/150',
    },
    {
      'name': 'Dr. Vargo Ho',
      'specialty': 'Neurologist',
      'rating': 4.6,
      'image': 'https://via.placeholder.com/150',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.arrow_back_ios_new),
                  Text(
                    'Consult Doctors',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.search),
                ],
              ),
              const SizedBox(height: 20),

              // Banner
              const CustomBanner(),

              const SizedBox(height: 20),

              // Categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('See All', style: TextStyle(color: Colors.purple)),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.05,
                  ),
                  itemCount: categories.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(width: 50),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return CategoryItem(
                      icon: category['icon'],
                      label: category['label'],
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Popular Doctors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Popular Doctor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('See All', style: TextStyle(color: Colors.purple)),
                ],
              ),
              const SizedBox(height: 12),

              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: doctors.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return DoctorCard(
                    name: doctor['name'],
                    specialty: doctor['specialty'],
                    rating: doctor['rating'],
                    imageUrl: doctor['image'],
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // Bottom Navbar (sederhana)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF9C6BFF),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(3, (index) {
              final bool isSelected = index == 0;
              final List<IconData> icons = [
                Icons.home,
                Icons.chat,
                Icons.person,
              ];

              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                  child: Icon(
                    icons[index],
                    color: isSelected ? Colors.black : Colors.white,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
