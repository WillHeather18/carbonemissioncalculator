import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';

class Journeys extends StatefulWidget {
  const Journeys({super.key});

  @override
  JourneysState createState() => JourneysState();
}

class JourneysState extends State<Journeys> {
  String carType = 'Petrol Car';
  DateTime? selectedDate;
  final TextEditingController distanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar(context),
        body: Stack(children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 120),
              child: Center(
                  child: SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Text(
                                'Vehicle Type',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              InputDecorator(
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  child: SizedBox(
                                      height: 15.0,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: carType,
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              carType = newValue!;
                                            });
                                          },
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'Petrol Car',
                                              child: Text('Petrol Car'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Diesel Car',
                                              child: Text('Diesel Car'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Electric Car',
                                              child: Text('Electric Car'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Train',
                                              child: Text('Train'),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Plane',
                                              child: Text('Plane'),
                                            ),
                                          ],
                                        ),
                                      )))
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          Column(
                            children: [
                              const Text(
                                'Distance Travelled (km)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              TextField(
                                controller: distanceController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          Column(
                            children: [
                              const Text(
                                'Date',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              OutlinedButton(
                                onPressed: () => selectDate(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(
                                      color: Colors.black, width: 1),
                                ),
                                child: Text(
                                  selectedDate != null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(selectedDate!)
                                      : 'Select date',
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 50.0),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedDate != null &&
                                  distanceController.text.isNotEmpty) {
                                submitJourney(context, carType,
                                    distanceController.text, selectedDate!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please select a date and enter a distance')),
                                );
                              }
                            },
                            child: const Text('Add Journey'),
                          )
                        ],
                      ))))
        ]));
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

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
