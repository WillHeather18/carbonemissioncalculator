import 'package:flutter/material.dart';

class Food extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(context),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Food',
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
