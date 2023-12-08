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
  Map<String, int> vehicleCo2 = {
    'Petrol Car': 170,
    'Diesel Car': 171,
    'Electric Car': 47,
    'Train': 35,
    'Plane': 193,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
          ),
          Center(
              child: SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50.0),
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
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          10.0)), // Set border radius here
                                ),
                              ),
                              child: SizedBox(
                                  height: 20.0,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
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
                            String co2 = ((int.parse(distanceController.text)) *
                                    vehicleCo2[carType]!)
                                .toString();
                            submitJourney(context, carType,
                                distanceController.text, selectedDate!, co2);
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
                  )))
        ]));
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
