import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF003893),
      title: Row(
        children: [
          Image.asset(
            'assets/twoflag.png',
            height: 60,
          ),
          const SizedBox(width: 10),
          const Text(
            'BhrastaBusters',
            style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.w600, 
              fontSize: 20,                
              fontFamily: 'Roboto',),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
