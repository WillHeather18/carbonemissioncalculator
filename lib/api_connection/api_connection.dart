import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carbonemissioncalculator/tablerowdata.dart';
import 'package:flutter/material.dart';
import 'package:carbonemissioncalculator/pagestate.dart';
import 'package:carbonemissioncalculator/widgets.dart';
import 'package:carbonemissioncalculator/pages/login.dart';

class API {
  static const hostConnect = "http://10.124.129.67/cec_api";
  static const hostConnectUser = "$hostConnect/user";
  static const hostConnectJourney = "$hostConnect/journey";

  //login user
  static const login = "$hostConnectUser/login.php";
  //signup user
  static const signup = "$hostConnectUser/signup.php";
  //add journey
  static const addJourney = "$hostConnectJourney/add_journey.php";
  //get all journies
  static const getAllJournies = "$hostConnectJourney/get_all_entries.php";
  //get entries from date
  static const getJournies = "$hostConnectJourney/get_entries_from_date.php";
  //get entries from timeframe
  static const getJourniesFromTimeframe =
      "$hostConnectJourney/get_entries_from_timeframe.php";
  //delete journey
  static const deleteJourney = "$hostConnectJourney/delete_entry.php";
  //edit journey
  static const editJourney = "$hostConnectJourney/edit_entry.php";
  //update co2
  static const updateCo2 = "$hostConnectJourney/update_co2.php";
}

// API Functions

//Get all Entries

Future<List<TableRowData>> getAllEntries() async {
  var res = await http.post(
    Uri.parse(API.getAllJournies),
    body: {},
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

//Get all Entries from a slelected month
Future<List<TableRowData>> getEntriesFromDate(DateTime selectedTime) async {
  var res = await http.post(
    Uri.parse(API.getJournies),
    body: {
      "selectedDate": selectedTime.toString(),
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

//Get all Entries from a slelected timeframe
Future<List<TableRowData>> getEntriesFromTimeframe(String time) async {
  var res = await http.post(
    Uri.parse(API.getJourniesFromTimeframe),
    body: {
      "timeframe": time,
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

//Submit entry
void submitJourney(BuildContext context, String vehicleType, String distance,
    DateTime selectedDate, String co2) async {
  var res = await http.post(
    Uri.parse(API.addJourney),
    body: {
      "vehicleType": vehicleType,
      "distance": distance,
      "selectedDate": selectedDate.toString(),
      "co2": co2,
    },
  );

  if (res.statusCode == 200 && res.body.isNotEmpty) {
    var responseBodyOfLogin = jsonDecode(res.body);
    if (responseBodyOfLogin['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journey added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journey not added, please try again')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request failed, please try again')),
    );
  }
}

//Edit entry
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
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Failed to edit entry')));
  }
  updateCO2(context, entry);
}

//Delete entry
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
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Failed to delete entry')));
  }
}

// update co2
void updateCO2(BuildContext context, TableRowData entry) async {
  Map<String, int> vehicleCo2 = {
    'Petrol Car': 170,
    'Diesel Car': 171,
    'Electric Car': 47,
    'Train': 35,
    'Plane': 193,
  };
  if (entry.selectedDistance != null) {
    int co2 = ((int.parse(entry.selectedDistance ?? entry.distance)) *
        vehicleCo2[entry.type]!);

    await http.post(
      Uri.parse(API.updateCo2),
      body: {
        "co2": co2.toString(),
        "id": entry.id,
      },
    );
  }
}

//Login user
void LoginVerification(BuildContext context, username, password) async {
  var res = await http.post(
    Uri.parse(API.login),
    body: {
      "username": username,
      "password": password,
    },
  );

  if (res.statusCode == 200 && res.body.isNotEmpty) {
    var responseBodyOfLogin = jsonDecode(res.body);
    if (responseBodyOfLogin['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } else {
      CustomWidgets.ShowErrorDialog(context, "Invalid username or password");
    }
  }
}

//Signup user
void SignupVerification(BuildContext context, username, password) async {
  var res = await http.post(
    Uri.parse(API.signup),
    body: {
      "username": username,
      "password": password,
    },
  );

  if (res.statusCode == 200 && res.body.isNotEmpty) {
    var responseBodyOfLogin = jsonDecode(res.body);
    if (responseBodyOfLogin['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
      CustomWidgets.ShowErrorDialog(context, "Account created successfully");
    } else if (responseBodyOfLogin['message'] == "Username already exists") {
      CustomWidgets.ShowErrorDialog(context, "Username already exists");
    } else {
      CustomWidgets.ShowErrorDialog(context, "Error connecting to server");
    }
  } else {
    CustomWidgets.ShowErrorDialog(context, "Error connecting to server");
  }
}
