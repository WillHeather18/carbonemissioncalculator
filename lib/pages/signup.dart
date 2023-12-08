// ignore_for_file: non_constant_identifier_names

import 'package:carbonemissioncalculator/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:carbonemissioncalculator/api_connection/api_connection.dart';
import 'package:carbonemissioncalculator/widgets/widgets.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Signup extends StatelessWidget {
  final TextEditingController _emailController =
      TextEditingController(); // Text field controller for email
  final TextEditingController _usernameController =
      TextEditingController(); // Text field controller for username
  final TextEditingController _passwordController =
      TextEditingController(); // Text field controller for password
  final TextEditingController _repasswordController =
      TextEditingController(); // Text field controller for re-entered password
  final FocusNode _usernameFocusNode =
      FocusNode(); // Focus node for username text field
  final FocusNode _passwordFocusNode =
      FocusNode(); // Focus node for password text field
  final FocusNode _repasswordFocusNode = FocusNode();

  Signup({super.key}); // Focus node for re-entered password text field

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xFF04471C)),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 35),
            child: Column(
              children: [
                SvgPicture.asset(
                  'assets/icons/Whitelogo.svg',
                  semanticsLabel: 'SVG Image',
                  width: 125.0,
                  height: 125.0,
                ),
                const SizedBox(height: 15.0),
                const Text("Carbon Emissions Calculator",
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20.0,
                        color: Colors.white))
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 250, left: 50.0, right: 50.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 120.0),
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 48.0,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _emailController,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_usernameFocusNode);
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
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
                  focusNode: _passwordFocusNode,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_repasswordFocusNode);
                  },
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
                  focusNode: _repasswordFocusNode,
                  onSubmitted: (value) {
                    PasswordVerification(context);
                  },
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
                    PasswordVerification(context);
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

  void PasswordVerification(BuildContext context) {
    String email = _emailController.text;
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
      SignupVerification(context, email, username, hashPassword(password));
    } else {
      CustomWidgets.ShowErrorDialog(context, "Passwords do not match");
    }
  }

  bool isValidPassword(String password) {
    bool hasUppercase = password.contains(RegExp(
        r'[A-Z]')); // Check if password contains at least one uppercase letter
    bool hasDigits = password.contains(
        RegExp(r'[0-9]')); // Check if password contains at least one digit
    bool hasLowercase = password.contains(RegExp(
        r'[a-z]')); // Check if password contains at least one lowercase letter
    bool hasMinLength =
        password.length >= 8; // Check if password is at least 8 characters long
    return hasDigits & hasUppercase & hasLowercase & hasMinLength;
  }
}

String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}
