import 'package:carbonemissioncalculator/api_connection/api_connection.dart';
import 'package:carbonemissioncalculator/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class Login extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(color: Color(0xFF04471C)),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.only(top: 300, left: 50.0, right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 150.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontFamily: 'Inter', fontSize: 48.0, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _usernameController,
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
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  LoginVerification(context, username, hashPassword(password));
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
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  String username = _usernameController.text;
                  String password = _passwordController.text;
                  LoginVerification(context, username, hashPassword(password));
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black, fontFamily: 'Inter'),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 750, left: 100),
          child: RichText(
              text: TextSpan(text: "Don't have an account?", children: [
            TextSpan(
              text: "Sign up",
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
            )
          ])),
        )
      ]),
    );
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
