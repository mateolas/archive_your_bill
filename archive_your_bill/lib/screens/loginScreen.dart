import 'package:flutter/material.dart';

import 'package:archive_your_bill/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: RaisedButton(
            child: Text('Move to main screen'),
            onPressed: () {
              setState(() {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage()),
                (Route<dynamic> route) => false);
              });
            },
          ),
        ));
  }
}
