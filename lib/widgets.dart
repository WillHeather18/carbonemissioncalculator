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
  final Map<String, double> vehicleDistribution;

  PieChartWidget({required this.vehicleDistribution});

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> sections =
        vehicleDistribution.entries.map((entry) {
      return PieChartSectionData(
        color: Colors
            .primaries[vehicleDistribution.keys.toList().indexOf(entry.key)],
        value: entry.value,
        title: entry.key,
        radius: 40,
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
}
