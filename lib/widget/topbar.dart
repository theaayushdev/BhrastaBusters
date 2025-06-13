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
            height: 40,
          ),
          const SizedBox(width: 40),
          const Text(
            'BhrastaBusters',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
