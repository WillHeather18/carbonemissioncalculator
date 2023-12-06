import 'package:carbonemissioncalculator/pages/login.dart';
import 'package:carbonemissioncalculator/pagestate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.isLightTheme ? Themes.light : Themes.dark,
      home: MyHomePage(),
    );
  }
}

class ThemeNotifier with ChangeNotifier {
  bool _isLightTheme = true;

  bool get isLightTheme => _isLightTheme;

  void toggleTheme() {
    _isLightTheme = !_isLightTheme;
    notifyListeners();
  }
}

class Themes {
  static final light = ThemeData(
      colorScheme: const ColorScheme.light(
    primary: Color(0xFF04471C),
    secondary: Colors.black,
    background: Colors.white,
    brightness: Brightness.light,
  ));

  static final dark = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: Colors.black,
      background: Color(0xFF04471C),
      brightness: Brightness.dark,
    ),
  );
}
