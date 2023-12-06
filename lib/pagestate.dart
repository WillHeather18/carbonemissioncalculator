import 'package:carbonemissioncalculator/pages/entries.dart';
import 'package:carbonemissioncalculator/pages/home.dart';
import 'package:carbonemissioncalculator/pages/journy.dart';
import 'package:carbonemissioncalculator/pages/settings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

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
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pages = [
      const Overview(),
      const Journeys(),
      const Entries(),
      const Settings()
    ];
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          _pageTitles[_currentPageIndex],
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        actions: [
          SizedBox(
            height: 50,
            width: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/icons/Whitelogo.svg'
                    : 'assets/icons/Greenlogo.svg',
              ),
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {
            setState(() {
              _currentPageIndex = 0;
            });
          },
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(40.0),
            bottom: Radius.circular(40.0),
          ),
          child: BottomNavigationBar(
            selectedItemColor: Theme.of(context).colorScheme.background,
            unselectedItemColor: Colors.grey,
            currentIndex: _currentPageIndex,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              // Overview widget
              BottomNavigationBarItem(
                icon: const Icon(Icons.pie_chart_outline),
                label: 'Overview',
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              // Journeys widget
              BottomNavigationBarItem(
                icon: const Icon(Icons.airplanemode_active),
                label: 'Journeys',
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              // Entries widget
              BottomNavigationBarItem(
                icon: const Icon(Icons.list_alt),
                label: 'Entries',
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              // Settings widget
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: 'Settings',
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
