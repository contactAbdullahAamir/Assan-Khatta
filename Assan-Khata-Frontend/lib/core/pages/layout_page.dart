import 'package:assan_khata_frontend/features/contact_management/presentation/pages/contact_home_page.dart';
import 'package:assan_khata_frontend/features/profile_management/presentation/pages/profile_section.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

import '../theme/app_pallete.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const LayoutPage(),
      );

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = [
    ContactHomePage(),
    ProfileSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Container(
          height: 110,
          child: BottomNavigationBar(
            backgroundColor: AppPallete.primaryTextColor,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 35,
                ),
                label: 'Individuals',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.account_box,
                  size: 35,
                ),
                label: 'Profile',
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: AppPallete.primaryColor,
            onTap: (index) {
              Vibration.vibrate(duration: 50);
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
      body: _pages[_currentIndex],
    );
  }
}
