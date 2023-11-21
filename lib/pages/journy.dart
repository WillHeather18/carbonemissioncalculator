import 'package:flutter/material.dart';

class Journeys extends StatefulWidget {
  @override
  JourneysState createState() => JourneysState();
}

class JourneysState extends State<Journeys> {
  String carType = 'Petrol Car';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar(context),
        body: Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: GridView.count(
              padding: EdgeInsets.only(top: 150, left: 50, right: 50),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 30,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Car Type',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: carType,
                      underline: Container(height: 2, color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          carType = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          child: Text('Petrol Car'),
                          value: 'Petrol Car',
                        ),
                        DropdownMenuItem(
                          child: Text('Diesel Car'),
                          value: 'Diesel Car',
                        ),
                        DropdownMenuItem(
                          child: Text('Electric Car'),
                          value: 'Electric Car',
                        ),
                        DropdownMenuItem(
                          child: Text('Train'),
                          value: 'Train',
                        ),
                        DropdownMenuItem(
                          child: Text('Plane'),
                          value: 'Plane',
                        ),
                      ],
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                    filled: true,
                    fillColor: Color(0xFF04471C),
                  ),
                ),
              ],
            )));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Journeys',
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
