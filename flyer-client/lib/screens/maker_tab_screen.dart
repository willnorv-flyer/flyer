import 'package:flutter/material.dart';
import 'package:flyer_client/screens/maker_my_page_screen.dart';
import 'package:flyer_client/screens/maker_ut_screen.dart';
import 'package:flyer_client/screens/tester_my_page_screen.dart';
import 'package:flyer_client/screens/tester_pre_market_screen.dart';

class MakerTabScreen extends StatefulWidget {
  const MakerTabScreen({super.key});

  @override
  State<MakerTabScreen> createState() => _MakerTabScreenState();
}

class _MakerTabScreenState extends State<MakerTabScreen> {
  int _selectedIndex = 0;
  Widget _selectedScreen = const MakerUTScreen();

  @override
  Widget build(BuildContext context) {
    // selected color 0 122 255
    const selectedColor = Color(0xFF007AFF);

    return Scaffold(
      body: _selectedScreen,
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          color: selectedColor,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          color: Theme.of(context).colorScheme.outline,
          fontWeight: FontWeight.w600,
          height: 1.5,
        ),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/maker_ut.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 0
                  ? selectedColor
                  : Theme.of(context).colorScheme.outline,
            ),
            label: 'UT',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/images/user.png',
              width: 24,
              height: 24,
              color: _selectedIndex == 1
                  ? selectedColor
                  : Theme.of(context).colorScheme.outline,
            ),
            label: '내 프로필',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 0) {
              _selectedScreen = const MakerUTScreen();
            } else {
              _selectedScreen = const MakerMyPageScreen();
            }
          });
        },
      ),
    );
  }
}
