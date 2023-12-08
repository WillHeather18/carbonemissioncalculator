import 'package:flutter/material.dart';

typedef OnHorizontalDatePickerSelected = void Function(DateTime dateTime);
typedef OnHorizontalDatePickerSubmitted = void Function(DateTime dateTime);

class HorizontalDatePicker extends StatefulWidget {
  final DateTime? initial;
  final OnHorizontalDatePickerSelected onSelected;
  final OnHorizontalDatePickerSubmitted? onSubmitted;
  const HorizontalDatePicker(
      {Key? key, this.initial, required this.onSelected, this.onSubmitted})
      : super(key: key);

  @override
  State<HorizontalDatePicker> createState() => _HorizontalDatePickerState();
}

class _HorizontalDatePickerState extends State<HorizontalDatePicker> {
  static const Map<int, String> _monthList = {
    DateTime.january: 'Jan',
    DateTime.february: 'Feb',
    DateTime.march: 'Mar',
    DateTime.april: 'Apr',
    DateTime.may: 'May',
    DateTime.june: 'Jun',
    DateTime.july: 'Jul',
    DateTime.august: 'Aug',
    DateTime.september: 'Sep',
    DateTime.october: 'Oct',
    DateTime.november: 'Nov',
    DateTime.december: 'Dec'
  };

  late DateTime _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initial ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _previous(),
        _month(),
        _year(),
        _next(),
      ],
    );
  }

  Widget _previous() {
    return IconButton(
        onPressed: () {
          setState(() {
            _current = DateTime(_current.year, _current.month - 1);
          });
          widget.onSelected(_current);
        },
        icon: const Icon(Icons.arrow_back_ios_sharp));
  }

  Widget _next() {
    DateTime nextMonth = DateTime(_current.year, _current.month + 1);
    if (nextMonth.isAfter(DateTime.now())) {
      return const SizedBox(
        width: 48, // width of IconButton
        height: 48, // height of IconButton
      ); // return an empty container
    } else {
      return IconButton(
        onPressed: () {
          setState(() {
            _current = DateTime(_current.year, _current.month + 1);
          });
          widget.onSelected(_current);
        },
        icon: const Icon(Icons.arrow_forward_ios_sharp),
      );
    }
  }

  Widget _month() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text('${_monthList[_current.month]}'),
    );
  }

  Widget _year() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text('${_current.year}'),
    );
  }
}
