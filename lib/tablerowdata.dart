class TableRowData {
  final String id;
  final String type;
  String? selectedType;
  final String distance;
  String? selectedDistance;
  final String date;
  String? selectedDate;
  final String co2;

  TableRowData(
      {required this.id,
      required this.type,
      this.selectedType,
      required this.distance,
      this.selectedDistance,
      required this.date,
      this.selectedDate,
      required this.co2});

  factory TableRowData.fromJson(Map<String, dynamic> json) {
    return TableRowData(
      id: json['id'],
      type: json['journey_type'],
      selectedType: json['journey_type'],
      distance: json['distance_travelled'],
      date: json['journey_date'],
      co2: json['co2'],
    );
  }
}
