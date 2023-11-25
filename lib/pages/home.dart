// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:carbonemissioncalculator/tablerowdata.dart';
import 'package:carbonemissioncalculator/widgets.dart';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';

class Overview extends StatefulWidget {
<<<<<<< HEAD
=======
  const Overview({super.key});

>>>>>>> 5c853cb215103a6adda5c33c24b218512e4928e5
  @override
  OverviewState createState() => OverviewState();
}

class OverviewState extends State<Overview> {
<<<<<<< HEAD
  String currentTimeframe = 'week';
  final List<String> timeframes = ['week', 'month', 'year', 'all time'];

=======
  late String selectedTimeframe = "week";
>>>>>>> 5c853cb215103a6adda5c33c24b218512e4928e5
  @override
  Widget build(BuildContext context) {
    print('Current Timeframe: $currentTimeframe');
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: appBar(context),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
            ),
<<<<<<< HEAD
            const Padding(
              padding: EdgeInsets.only(top: 170.0, left: 25.0),
              child: Text(
                'Vehicle Distribution',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 180, bottom: 220),
              child: PieChartWidget(
                  vehicleDistributionFuture:
                      calculateVehicleTypeDistribution(currentTimeframe)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 250.0, top: 170),
              child: Column(
                children: [
                  const Text("Total CO2",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter')),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: FutureBuilder<String>(
                      future: GetTotalCO2(currentTimeframe),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text('${snapshot.data}',
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight
                                        .bold)); // snapshot.data is your total CO2
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 100),
              child: DropdownButton<String>(
                value: currentTimeframe,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    currentTimeframe = newValue ?? currentTimeframe;
                  });
                },
                items: timeframes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
=======
            Padding(
                padding: const EdgeInsets.only(top: 85),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF04471C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        child: const Text(
                          'Week',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          buttonPressed('week');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('week')),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF04471C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        child: const Text(
                          'Month',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          buttonPressed('month');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('month')),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF04471C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        child: const Text(
                          'Year',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          buttonPressed('year');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('year')),
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF04471C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        child: const Text(
                          'All-Time',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          buttonPressed('all');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('all')),
                          );
                        },
                      ),
                    ),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 200),
              child: Center(
                  child: FutureBuilder<Map<String, double>>(
                future: calculateVehicleTypeDistribution(selectedTimeframe),
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, double>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // show a loading spinner while waiting
                  } else if (snapshot.hasError) {
                    return Text(
                        'Error: ${snapshot.error}'); // show error message if any error occurred
                  } else if (snapshot.data!.isEmpty) {
                    return const Text(
                        'No data available'); // show error message if any error occurred
                  } else {
                    return PieChartWidget(
                        vehicleDistribution: snapshot
                            .data!); // show pie chart if data is available
                  }
                },
              )),
            )
>>>>>>> 5c853cb215103a6adda5c33c24b218512e4928e5
          ],
        ));
  }

  void buttonPressed(String time) {
    setState(() {
      selectedTimeframe = time;
    });
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

  Future<Map<String, double>> calculateVehicleTypeDistribution(
      String time) async {
    List<TableRowData> rows = await getEntriesFromTimeframe(time);
    Map<String, int> counts = {};
    int total = 0;

    for (var row in rows) {
      String vehicleType = row.type;
      if (counts.containsKey(vehicleType)) {
        counts[vehicleType] = (counts[vehicleType] ?? 0) + 1;
      } else {
        counts[vehicleType] = 1;
      }
      total++;
    }

    Map<String, double> distribution = {};
    counts.forEach((vehicleType, count) {
      distribution[vehicleType] = (count / total) * 100;
    });

    return distribution;
  }

  Future<String> GetTotalCO2(String time) async {
    List<TableRowData> rows = await getEntriesFromTimeframe(time);
    int total = 0;

    for (var row in rows) {
      int co2 = int.parse(row.co2);
      total += co2;
    }
    return total.toString();
  }
}
