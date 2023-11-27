import 'package:carbonemissioncalculator/pages/entries.dart';
import 'package:carbonemissioncalculator/pages/home.dart';
import 'package:carbonemissioncalculator/pages/journy.dart';
import 'package:carbonemissioncalculator/pages/settings.dart';

import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  PageState createState() => PageState();
}

class PageState extends State<MyHomePage> {
  int _currentPageIndex = 0;
  late List<Widget> _pages;
  final List<String> _pageTitles = [
    'Overview',
    'Journeys',
    'Entries',
    'Settings'
  ]; // Add your page titles here
  @override
  void initState() {
    super.initState();
    _pages = [Overview(), Journeys(), Entries(), Settings()];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: Text(
            _pageTitles[_currentPageIndex],
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter'),
          ),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          elevation: 0.0,
        ),
        body: _pages[_currentPageIndex],
        bottomNavigationBar: Container(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(40.0), bottom: Radius.circular(40.0)),
                child: BottomNavigationBar(
                  selectedItemColor: Theme.of(context).colorScheme.background,
                  unselectedItemColor: Colors.grey,
                  currentIndex: _currentPageIndex,
                  onTap: _onItemTapped,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.pie_chart_outline),
                        label: 'Overview',
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.airplanemode_active),
                        label: 'Journeys',
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.list_alt),
                        label: 'Entries',
                        backgroundColor: Theme.of(context).colorScheme.primary),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.settings),
                        label: 'Settings',
                        backgroundColor: Theme.of(context).colorScheme.primary),
                  ],
                ))));
  }
}
