import 'package:carbonemissioncalculator/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';

class Signup extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xFF04471C)),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 350.0, left: 50.0),
          child: Text(
            'Sign up',
            style: TextStyle(
                fontFamily: 'Inter', fontSize: 48.0, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 350, left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: _repasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  labelText: ' Re-enter Password',
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  String repassword = _repasswordController.text;
                  SignupVerification(context, username, password, repassword);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text(
                  'Sign up',
                  style: TextStyle(color: Colors.black, fontFamily: 'Inter'),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 750, left: 100),
          child: RichText(
              text: TextSpan(text: "Already have an account? ", children: [
            TextSpan(
              text: "Log in",
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
            )
          ])),
        )
      ]),
    );
  }

  void SignupVerification(
      BuildContext context, username, password, repassword) async {
    if (password == repassword) {
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
          ShowErrorDialog(context, "Account created successfully");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        } else {
          ShowErrorDialog(context, "Error creating account");
        }
      } else {
        ShowErrorDialog(context, "Error connecting to server");
      }
    } else {
      ShowErrorDialog(context, "Passwords do not match");
    }
  }

  void ShowErrorDialog(BuildContext context, String message) {
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
