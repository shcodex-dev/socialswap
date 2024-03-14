// ignore_for_file: unused_local_variable

import 'package:socialswap/pages/cryptoNewsList.dart';
import 'package:socialswap/pages/mainHome.dart';
import 'package:socialswap/pages/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:socialswap/pages/home.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentIndex = 0;

  List<Widget> pages = [
    MainHome(),
    CryptoNewsList(),
    Home(),
    ViewProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            onTap: ((value) {
              setState(() {
                _currentIndex = value;
              });
            }),
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/1.1.png',
                    height: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Image.asset(
                    'assets/icons/1.2.png',
                    height: myHeight * 0.03,
                    color: Color(0xffFBC700),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/2.1.png',
                    height: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Image.asset(
                    'assets/icons/2.2.png',
                    height: myHeight * 0.03,
                    color: Color(0xffFBC700),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/6.1.png',
                    height: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Image.asset(
                    'assets/icons/6.2.png',
                    height: myHeight * 0.03,
                    color: Color(0xffFBC700),
                  )),
              BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/icons/4.1.png',
                    height: myHeight * 0.03,
                    color: Colors.grey,
                  ),
                  label: '',
                  activeIcon: Image.asset(
                    'assets/icons/4.2.png',
                    height: myHeight * 0.03,
                    color: Color(0xffFBC700),
                  )),
            ]),
      ),
    );
  }
}
