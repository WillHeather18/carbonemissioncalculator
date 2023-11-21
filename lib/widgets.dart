import 'package:flutter/material.dart';

import 'package:fl_chart/fl_chart.dart';

class pieChart extends StatelessWidget {
  const pieChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 60,
        sections: [
          PieChartSectionData(
            color: Colors.red,
            value: 40,
            title: '40%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          ),
          PieChartSectionData(
            color: const Color(0xfff8b250),
            value: 30,
            title: '30%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          ),
          PieChartSectionData(
            color: const Color(0xff845bef),
            value: 30,
            title: '30%',
            radius: 50,
            titleStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          ),
        ],
      ),
    );
  }
}
