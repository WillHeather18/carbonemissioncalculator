import 'package:flutter/material.dart';
import 'package:carbonemissioncalculator/tablerowdata.dart';
import 'package:carbonemissioncalculator/widgets.dart';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  OverviewState createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  late String selectedTimeframe = "week";
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
}
