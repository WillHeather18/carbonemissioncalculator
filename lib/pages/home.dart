// ignore_for_file: prefer_const_constructors

import 'package:carbonemissioncalculator/widgets.dart';
import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar(context),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
            ),
            Container(height: 450, child: Center(child: pieChart()))
          ],
        ));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Overview',
        style: TextStyle(
            color: Color(0xFF04471C),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter'),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
    );
  }
}
