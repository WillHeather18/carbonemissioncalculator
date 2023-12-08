import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carbonemissioncalculator/main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        // Container widget to provide a background color
        Container(
          decoration:
              BoxDecoration(color: Theme.of(context).colorScheme.background),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              children: [
                // Text widget to display "Toggle Theme"
                const Text("Toggle Theme"),
                // Switch widget to toggle the theme
                Switch(
                  value: Provider.of<ThemeNotifier>(context).isLightTheme,
                  onChanged: (value) {
                    // Update the theme when the switch is toggled
                    Provider.of<ThemeNotifier>(context, listen: false)
                        .toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
