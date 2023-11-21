import 'package:carbonemissioncalculator/pages/entries.dart';
import 'package:carbonemissioncalculator/pages/home.dart';
import 'package:carbonemissioncalculator/pages/journy.dart';
import 'package:carbonemissioncalculator/pages/food.dart';
import 'package:carbonemissioncalculator/pages/settings.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  PageState createState() => PageState();
}

class PageState extends State<MyHomePage> {
  int _currentPageIndex = 0;
  final List<Widget> _pages = [
    Overview(),
    Food(),
    Journeys(),
    Entries(),
    Settings()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: _pages[_currentPageIndex],
        bottomNavigationBar: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40.0), bottom: Radius.circular(40.0)),
                child: BottomNavigationBar(
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey,
                  currentIndex: _currentPageIndex,
                  onTap: _onItemTapped,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.pie_chart_outline),
                        label: 'Overview',
                        backgroundColor: Color(0xFF04471C)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.food_bank_outlined),
                        label: 'Food',
                        backgroundColor: Color(0xFF04471C)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.airplanemode_active),
                        label: 'Journeys',
                        backgroundColor: Color(0xFF04471C)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.list_alt),
                        label: 'Entries',
                        backgroundColor: Color(0xFF04471C)),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                        backgroundColor: Color(0xFF04471C)),
                  ],
                ))));
  }
}
