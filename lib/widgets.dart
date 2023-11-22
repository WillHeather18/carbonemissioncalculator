import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomWidgets {
  static void ShowErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class PieChartWidget extends StatelessWidget {
  final Future<Map<String, double>> vehicleDistributionFuture;

  PieChartWidget({required this.vehicleDistributionFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
      future: vehicleDistributionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<PieChartSectionData> sections =
              snapshot.data!.entries.map((entry) {
            return PieChartSectionData(
              color: Colors
                  .primaries[snapshot.data!.keys.toList().indexOf(entry.key)],
              value: entry.value,
              title: entry.key,
              radius: 50,
            );
          }).toList();

          return PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 40,
              sections: sections,
            ),
          );
        }
      },
    );
  }
}
