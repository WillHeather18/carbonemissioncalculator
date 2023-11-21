//import 'package:carbonemissioncalculator/pages/login.dart';
//import 'package:carbonemissioncalculator/mysql.dart';
//import 'package:carbonemissioncalculator/pages/home.dart';
import 'package:carbonemissioncalculator/pagestate.dart';
//import 'package:carbonemissioncalculator/pages/login.dart';
//import 'package:carbonemissioncalculator/pagestate.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHomePage());
  }
}
