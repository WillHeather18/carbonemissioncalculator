import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carbonemissioncalculator/main.dart';

class Settings extends StatefulWidget {
  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
        ),
        Center(
          child: Switch(
            value: Provider.of<ThemeNotifier>(context).isLightTheme,
            onChanged: (value) {
              Provider.of<ThemeNotifier>(context, listen: false).toggleTheme();
            },
          ),
        ),
      ]),
    );
  }
}
