// lib/widget/bottom_nav.dart
import 'package:flutter/material.dart';
import '../screens/homescreen.dart';
import '../screens/information.dart';
import '../screens/faq.dart';
import '../screens/report.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, required this.selectedIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == selectedIndex) return;

    Widget targetPage;
    switch (index) {
      case 0:
        targetPage =  HomePage();
        break;
      case 1:
        targetPage =  Emergency();
        break;
      case 2:
        targetPage =  FAQPage();
        break;
      case 3:
        targetPage =  ReportPage();
        break;
      default:
        targetPage =  HomePage();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: const Color(0xFF003893),
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onItemTapped(context, index),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        
       
        BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
         BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'FAQ'),
        
      ],
    );
  }
}
