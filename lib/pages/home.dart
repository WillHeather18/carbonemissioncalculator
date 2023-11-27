// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:carbonemissioncalculator/tablerowdata.dart';
import 'package:carbonemissioncalculator/widgets.dart';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';

class Overview extends StatefulWidget {
  @override
  OverviewState createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  String currentTimeframe = 'week';
  final List<String> timeframes = ['week', 'month', 'year', 'all time'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
            ),
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
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                underline: Container(
                  height: 2,
                  color: Theme.of(context).colorScheme.primary,
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
          ],
        ));
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
