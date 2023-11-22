import 'package:flutter/material.dart';
import 'package:carbonemissioncalculator/widgets/monthselector.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';

class Entries extends StatefulWidget {
  const Entries({Key? key}) : super(key: key);

  @override
  EntriesState createState() => EntriesState();
}

class EntriesState extends State<Entries> {
  late DateTime selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = DateTime.now(); // Initialize selectedTime
  }

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
            padding: const EdgeInsets.only(top: 75),
            child: Column(
              children: [
                HorizontalDatePicker(
                  onSelected: (DateTime time) {
                    setState(() {
                      selectedTime = time;
                    });
                  },
                ),
                EntriesSection(selectedTime: selectedTime),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'Entries',
        style: TextStyle(
            color: Color(0xFF04471C),
            fontSize: 18,
            fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      elevation: 0.0,
    );
  }
}

class EntriesSection extends StatefulWidget {
  final DateTime selectedTime;

  const EntriesSection({required this.selectedTime});

  @override
  _EntriesSectionState createState() => _EntriesSectionState();
}

class _EntriesSectionState extends State<EntriesSection> {
  Future<List<TableRowData>>? entries;

  @override
  void didUpdateWidget(covariant EntriesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTime != widget.selectedTime) {
      entries = getEntries();
    }
  }

  Future<List<TableRowData>> getEntries() async {
    var res = await http.post(
      Uri.parse(API.getJournies),
      body: {
        "selectedDate": widget.selectedTime.toString(),
      },
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      var responseBody = json.decode(res.body);
      if (responseBody is Map<String, dynamic> && responseBody['success']) {
        List<TableRowData> tableRows = (responseBody['journeys'] as List)
            .map((data) => TableRowData.fromJson(data))
            .toList();
        return tableRows;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load entries');
    }
  }

  Widget BuildTable(BuildContext context) {
    Future<List<TableRowData>> entries = getEntries();
    return FutureBuilder<List<TableRowData>>(
      future: entries,
      builder:
          (BuildContext context, AsyncSnapshot<List<TableRowData>> snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text('Journey Type'),
                ),
                DataColumn(
                  label: Text('Distance'),
                ),
                DataColumn(
                  label: Text('Date'),
                ),
                DataColumn(
                  label: Text('Actions'),
                ),
              ],
              rows: BuildRows(context, snapshot.data!),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  List<DataRow> BuildRows(BuildContext context, List<TableRowData> entries) {
    return entries
        .map((entry) => DataRow(
              cells: <DataCell>[
                DataCell(DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: entry.type,
                    onChanged: (String? newValue) async {
                      entry.selectedType = newValue!;
                      EditEntry(context, entry);
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
                )),
                DataCell(TextField(
                  controller: TextEditingController()..text = entry.distance,
                  decoration: const InputDecoration(border: InputBorder.none),
                  onChanged: (text) {
                    entry.selectedDistance = text;
                    EditEntry(context, entry);
                  },
                )),
                DataCell(
                  GestureDetector(
                    onTap: () async {
                      DateTime newDate = await selectDate(context, entry);
                      entry.selectedDate = newDate.toString();
                      EditEntry(context, entry);
                    },
                    child: Text(entry.date),
                  ),
                ),
                DataCell(
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      DeleteEntry(context, entry);
                    },
                  ),
                ),
              ],
            ))
        .toList();
  }

  Future<DateTime> selectDate(BuildContext context, TableRowData entry) async {
    final DateTime initialDate = DateTime.parse(entry.date);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    return picked ?? initialDate;
  }

  void DeleteEntry(BuildContext context, TableRowData entry) async {
    var res = await http.post(
      Uri.parse(API.deleteJourney),
      body: {
        "id": entry.id,
      },
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry deleted successfully')));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete entry')));
    }
  }

  void EditEntry(BuildContext context, TableRowData entry) async {
    var res = await http.post(
      Uri.parse(API.editJourney),
      body: {
        "id": entry.id,
        "type": entry.selectedType ?? entry.type,
        "distance": entry.selectedDistance ?? entry.distance,
        "date": entry.selectedDate ?? entry.date,
      },
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entry edited successfully')));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to edit entry')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BuildTable(context);
  }
}

class TableRowData {
  final String id;
  final String type;
  String? selectedType;
  final String distance;
  String? selectedDistance;
  final String date;
  String? selectedDate;

  TableRowData(
      {required this.id,
      required this.type,
      this.selectedType,
      required this.distance,
      this.selectedDistance,
      required this.date,
      this.selectedDate});

  factory TableRowData.fromJson(Map<String, dynamic> json) {
    return TableRowData(
      id: json['id'],
      type: json['journey_type'],
      selectedType: json['journey_type'],
      distance: json['distance_travelled'],
      date: json['journey_date'],
    );
  }
}
