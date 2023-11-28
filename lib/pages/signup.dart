import 'package:carbonemissioncalculator/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';
import 'package:carbonemissioncalculator/widgets.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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
                  if (!isValidPassword(password)) {
                    CustomWidgets.ShowErrorDialog(
                        context,
                        "Password must meet the following requirements:\n"
                        "- At least 8 characters long\n"
                        "- Contains at least one uppercase letter\n"
                        "- Contains at least one lowercase letter\n"
                        "- Contains at least one number");
                  } else if (password == repassword) {
                    SignupVerification(
                        context, username, hashPassword(password));
                  } else {
                    CustomWidgets.ShowErrorDialog(
                        context, "Passwords do not match");
                  }
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

  bool isValidPassword(String password) {
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasMinLength = password.length >= 8;
    return hasDigits & hasUppercase & hasLowercase & hasMinLength;
  }
}

String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}
