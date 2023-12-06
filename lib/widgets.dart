import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

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
  final Color baseColor = const Color.fromARGB(255, 77, 130, 96);

  const PieChartWidget({super.key, required this.vehicleDistributionFuture});

  @override
  Widget build(BuildContext context) {
    List<Color> contrastingColors = getContrastingColors(baseColor);
    List<Color> pieChartColors = List.generate(
        5, (index) => contrastingColors[index % contrastingColors.length]);
    return FutureBuilder<Map<String, double>>(
      future: vehicleDistributionFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data');
        } else {
          List<PieChartSectionData> sections =
              snapshot.data!.entries.map((entry) {
            return PieChartSectionData(
              color: pieChartColors.removeAt(0),
              value: entry.value,
              title: entry.key,
              radius: 50,
              titleStyle:
                  const TextStyle(color: Colors.white, fontFamily: 'Inter'),
            );
          }).toList();

          return PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 20,
              sections: sections,
            ),
          );
        }
      },
    );
  }

  List<Color> getContrastingColors(Color baseColor) {
    return [
      Color.fromARGB(
          255, (baseColor.red + 128) % 256, baseColor.green, baseColor.blue),
      Color.fromARGB(
          255, baseColor.red, (baseColor.green + 128) % 256, baseColor.blue),
      Color.fromARGB(
          255, baseColor.red, baseColor.green, (baseColor.blue + 128) % 256),
      Color.fromARGB(255, (baseColor.red + 128) % 256,
          (baseColor.green + 128) % 256, baseColor.blue),
      Color.fromARGB(255, baseColor.red, (baseColor.green + 128) % 256,
          (baseColor.blue + 128) % 256),
    ];
  }
}

class LineChartWidget extends StatelessWidget {
  final Future<List<FlSpot>> lineChartData;
  final String timeframe;

  LineChartWidget(
      {super.key, required this.lineChartData, required this.timeframe});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FlSpot>>(
        future: lineChartData, // replace 'time' with the actual time frame
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            double? maxValue = snapshot.data
                ?.reduce((curr, next) => curr.y > next.y ? curr : next)
                .y;
            return LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: false,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Colors.white,
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Colors.white,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(
                  border: const Border(
                    left: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    bottom: BorderSide(
                      color: Colors.white,
                      width: 2,
                    ),
                    right: BorderSide.none,
                    top: BorderSide.none,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      interval: maxValue! / 5,
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (double value, TitleMeta meta) => Text(
                          '${value.toInt()} kg',
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      interval: timeframe == 'year' ? 2 : 1,
                      showTitles: true,
                      reservedSize: 25,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final labels = timeframe == 'week'
                            ? getLast7Days()
                            : timeframe == 'month'
                                ? getLast4Weeks()
                                : timeframe == "year"
                                    ? getLast12Months()
                                    : getAllTimeYears(snapshot.data!.length);
                        if (timeframe == 'week' && (value < 0 || value > 6)) {
                          return const SizedBox();
                        } else if (timeframe == 'month' &&
                            (value < 0 || value > 3)) {
                          return const SizedBox();
                        } else if (timeframe == 'year' &&
                            (value < 0 || value > 11)) {
                          return const SizedBox();
                        }
                        return Text(
                          labels[value.toInt() % labels.length],
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false, reservedSize: 0),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false, reservedSize: 0),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: snapshot.data!,
                    isCurved: false,
                    barWidth: 2.5,
                    color: Colors.white,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color:
                          const Color.fromARGB(0, 115, 137, 156).withOpacity(1),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  List<String> getLast12Months() {
    final now = DateTime.now();
    return List<String>.generate(12, (index) {
      final month = DateTime(now.year, now.month - index, 1);
      return DateFormat('MMM').format(month);
    }).reversed.toList();
  }

  List<String> getLast7Days() {
    final now = DateTime.now();
    return List<String>.generate(7, (index) {
      final day = now.subtract(Duration(days: index));
      return DateFormat('E').format(day);
    }).reversed.toList();
  }

  List<String> getLast4Weeks() {
    final now = DateTime.now();
    return List<String>.generate(4, (index) {
      final weekStart = now.subtract(Duration(days: 7 * index));
      return '${weekStart.month}/${weekStart.day}';
    }).reversed.toList();
  }

  List<String> getAllTimeYears(int numberOfYears) {
    final now = DateTime.now().year;
    return List<String>.generate(numberOfYears, (index) {
      return (now - index).toString();
    }).reversed.toList();
  }
}
