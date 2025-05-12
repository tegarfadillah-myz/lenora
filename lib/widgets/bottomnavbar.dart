import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color activeBgColor = Colors.white;
    final Color activeIconColor = Color(0xFF1C3F60);
    final Color inactiveIconColor = Colors.white;
    final Color navBarBgColor = Color(0xFF1C3F60);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 45),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: navBarBgColor,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Active Home Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: activeBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.home_outlined, color: activeIconColor, size: 20),
          ),
          const SizedBox(width: 40),
          // Calendar Icon
          Icon(
            Icons.calendar_today_outlined,
            color: inactiveIconColor,
            size: 20,
          ),
          const SizedBox(width: 40),
          // Chat Icon
          Icon(Icons.chat_bubble_outline, color: inactiveIconColor, size: 20),
          const SizedBox(width: 40),
          // Settings Icon
          Icon(Icons.settings_outlined, color: inactiveIconColor, size: 20),
        ],
      ),
    );
  }
}
