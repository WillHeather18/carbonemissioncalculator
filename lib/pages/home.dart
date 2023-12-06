// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:carbonemissioncalculator/tablerowdata.dart';
import 'package:carbonemissioncalculator/widgets.dart';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:dots_indicator/dots_indicator.dart';

class Overview extends StatefulWidget {
  @override
  OverviewState createState() => OverviewState();
}

class OverviewState extends State<Overview> {
  String currentTimeframe = 'week';
  final List<String> timeframes = ['week', 'month', 'year', 'all time'];
  late List<Widget> scrollList;
  ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  @override
  Widget build(BuildContext context) {
    List<Widget> scrollList = [
      Stack(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 5, left: 20),
            child: Text(
              'Vehicle Distribution',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: PieChartWidget(
                vehicleDistributionFuture:
                    calculateVehicleTypeDistribution(currentTimeframe)),
          ),
        ],
      ),
      Column(
        children: [
          const Text("Total CO2",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Inter',
                  color: Colors.white)),
          Padding(
            padding: const EdgeInsets.only(top: 65),
            child: FutureBuilder<String>(
              future: GetTotalCO2(currentTimeframe),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                        '${(double.parse(snapshot.data!) / 1000).toStringAsFixed(2)} kg',
                        style: const TextStyle(
                            fontSize: 40,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                            color: Colors
                                .white)); // snapshot.data is your total CO2
                  }
                }
              },
            ),
          ),
        ],
      )
    ];

    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background),
            ),
            Positioned(
              top: 50, // Adjust as needed
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: ScrollSnapList(
                    onItemFocus: (int index) {
                      currentIndex.value = index;
                    },
                    itemSize: 250, // Match the width of the Container
                    itemCount: 2,
                    focusOnItemTap: true,
                    updateOnScroll: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(right: 50, bottom: 5, top: 5),
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 77, 130, 96),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: scrollList[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 248,
              left: MediaQuery.of(context).size.width / 2 - 20,
              child: ValueListenableBuilder<int>(
                valueListenable: currentIndex,
                builder: (context, value, child) {
                  return DotsIndicator(
                    dotsCount: 2,
                    position: value,
                    decorator: DotsDecorator(
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 270, left: 20.0, right: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 77, 130, 96),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                height: 350,
                width: 350, // Set the height you want
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Text(
                        '(CO2 Emission)',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: LineChartWidget(
                            lineChartData: getCO2DataForChart(currentTimeframe),
                            timeframe: currentTimeframe),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: DropdownButton<String>(
                value: currentTimeframe,
                icon: const Icon(Icons.arrow_downward),
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

  Future<List<FlSpot>> getCO2DataForChart(String time) async {
    List<TableRowData> rows = await getEntriesFromTimeframe(time);
    List<FlSpot> chartData = [];
    if (rows.contains(null)) {
      return [];
    }

    if (time == 'week') {
      List<FlSpot> chartData =
          List.generate(7, (index) => FlSpot(index.toDouble(), 0));
      for (var i = 0; i < rows.length; i++) {
        int dayOfWeek = DateTime.parse(rows[i].date).weekday -
            1; // Assuming 'date' is a property of TableRowData
        double co2 = double.parse(rows[i].co2) / 1000;
        chartData[dayOfWeek] = FlSpot(dayOfWeek.toDouble(), co2);
      }

      return chartData;
    } else if (time == 'month') {
      chartData = List.generate(4, (index) => FlSpot(index.toDouble(), 0));

      for (var i = 0; i < rows.length; i++) {
        DateTime rowDate = DateTime.parse(rows[i].date);
        int weekOfLast4Weeks = getWeekOfLast4Weeks(rowDate);
        double co2 = double.parse(rows[i].co2) / 1000;
        chartData[weekOfLast4Weeks] = FlSpot(
            weekOfLast4Weeks.toDouble(), chartData[weekOfLast4Weeks].y + co2);
      }

      return chartData;
    } else if (time == 'year') {
      chartData = List.generate(12, (index) => FlSpot(index.toDouble(), 0));

      for (var i = 0; i < rows.length; i++) {
        DateTime rowDate = DateTime.parse(rows[i].date);
        int monthOfLast12Months = getMonthOfLast12Months(rowDate);
        double co2 = double.parse(rows[i].co2) / 1000;
        chartData[monthOfLast12Months] = FlSpot(monthOfLast12Months.toDouble(),
            chartData[monthOfLast12Months].y + co2);
      }
      return chartData;
    } else {
      rows.sort(
          (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));

      int earliestYear = DateTime.parse(rows.first.date).year;
      int currentYear = DateTime.now().year;
      int yearsCount = currentYear - earliestYear + 1;

      List<FlSpot> chartData =
          List.generate(yearsCount, (index) => FlSpot(index.toDouble(), 0));

      for (var i = 0; i < rows.length; i++) {
        DateTime rowDate = DateTime.parse(rows[i].date);
        double co2 = double.parse(rows[i].co2) / 1000;
        int yearIndex = rowDate.year - earliestYear;
        chartData[yearIndex] =
            FlSpot(yearIndex.toDouble(), chartData[yearIndex].y + co2);
      }

      return chartData;
    }
  }

  int getWeekOfLast4Weeks(DateTime date) {
    int differenceInDays = DateTime.now().difference(date).inDays;
    if (differenceInDays < 28) {
      return differenceInDays ~/ 7;
    }
    return -1;
  }

  int getMonthOfLast12Months(DateTime date) {
    int currentYear = DateTime.now().year;
    int currentMonth = DateTime.now().month;
    int rowYear = date.year;
    int rowMonth = date.month;

    int differenceInMonths =
        (currentYear - rowYear) * 12 + (currentMonth - rowMonth);
    if (differenceInMonths >= 0 && differenceInMonths < 12) {
      return differenceInMonths;
    }
    return -1;
  }
}
