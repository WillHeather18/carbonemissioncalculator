import 'package:flutter/material.dart';
import 'package:carbonemissioncalculator/tablerowdata.dart';
import 'package:carbonemissioncalculator/widgets.dart';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';

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
            Container(
                height: 450,
                child: Center(
                    child: PieChartWidget(
                        vehicleDistributionFuture:
                            calculateVehicleTypeDistribution())))
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

  Future<Map<String, double>> calculateVehicleTypeDistribution() async {
    List<TableRowData> rows = await getAllEntries();
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
