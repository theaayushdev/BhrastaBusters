import 'dart:async';
import 'dart:convert';
import 'package:bhrastabusters/widget/topbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:bhrastabusters/screens/secondpage.dart';
import '../screens/information.dart';
import '../screens/faq.dart';
import '../screens/report.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _blinkController;

  final List<String> _imagePaths = [
    'assets/toppage.png',
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _imagePaths.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _blinkController.dispose();
    super.dispose();
  }

  Future<void> _fetchTokenAndNavigate() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.16.3.155:5000/GenerateToken'),
      );

      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(token: token),
          ),
        );
      } else {
        print("Failed to fetch token. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching token: $e");
    }
  }

  void _onNavItemTapped(int index) {
    if (index == 0) {
      setState(() {
        _selectedIndex = index;
      });
    } else {
      switch (index) {
        case 1:
          Navigator.push(context, MaterialPageRoute(builder: (_) => Emergency()));
          break;
        case 2:
          Navigator.push(context, MaterialPageRoute(builder: (_) => FAQPage()));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text(
                'Navigation',
                style: TextStyle(color: Color(0xFF003893), fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF003893)),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Color(0xFF003893)),
              title: const Text('Emergency Info'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => Emergency()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer, color: Color(0xFF003893)),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => FAQPage()));
              },
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? Stack(
              children: [
                // Faded background image on bottom half
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Opacity(
                    opacity: 0.08,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/twoflag.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Main scrollable content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      // Sliding Image
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            height: 160,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: _imagePaths.length,
                              itemBuilder: (context, index) {
                                return Image.asset(
                                  _imagePaths[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Animated text with cursor closely aligned
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DefaultTextStyle(
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF003893),
                                ),
                                child: AnimatedTextKit(
                                  isRepeatingAnimation: false,
                                  totalRepeatCount: 1,
                                  animatedTexts: [
                                    TyperAnimatedText(
                                      'To the people, For the people, By the people',
                                      speed: Duration(milliseconds: 50),
                                    ),
                                  ],
                                ),
                              ),
                              AnimatedBuilder(
                                animation: _blinkController,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: _blinkController.value,
                                    child: const Text(
                                      '|',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF003893),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 200),
                    ],
                  ),
                ),

                // Buttons at bottom half
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.15,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: _fetchTokenAndNavigate,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF003893),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Report', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _fetchTokenAndNavigate,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF003893),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Status', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF003893),
        unselectedItemColor: Colors.grey,
        onTap: _onNavItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.emergency), label: 'Emergency'),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), label: 'FAQ'),
        ],
      ),
    );
  }
}
