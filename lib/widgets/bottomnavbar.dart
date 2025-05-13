import 'package:flutter/material.dart';
import '../views/beranda/HomePage.dart';
import '../views/article_page.dart';
import '../views/dokter/dokter.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color activeBgColor = Colors.white;
    final Color activeIconColor = const Color(0xFF1C3F60);
    final Color inactiveIconColor = Colors.white;
    final Color navBarBgColor = const Color(0xFF1C3F60);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: navBarBgColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home
          GestureDetector(
            onTap: () {
              if (currentIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: currentIndex == 0 ? activeBgColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.home_outlined,
                color: currentIndex == 0 ? activeIconColor : inactiveIconColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 40),

          // Artikel
          GestureDetector(
            onTap: () {
              if (currentIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ArticlePage()),
                );
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: currentIndex == 1 ? activeBgColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.article_outlined,
                color: currentIndex == 1 ? activeIconColor : inactiveIconColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 40),
          GestureDetector(
            onTap: () {
              if (currentIndex != 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorPage()),
                );
              }
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: currentIndex == 2 ? activeBgColor : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                color: currentIndex == 2 ? activeIconColor : inactiveIconColor,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 40),

          // Chat
          // Container(
          //   width: 40,
          //   height: 40,
          //   child: Icon(
          //     Icons.chat_bubble_outline,
          //     color: inactiveIconColor,
          //     size: 20,
          //   ),
          // ),
          // const SizedBox(width: 40),

          // Settings
          Container(
            width: 40,
            height: 40,
            child: Icon(
              Icons.settings_outlined,
              color: inactiveIconColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
