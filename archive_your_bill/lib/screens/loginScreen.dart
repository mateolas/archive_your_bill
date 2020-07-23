import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:archive_your_bill/main.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>(); //to use form

  String _email;
  String _password;

  //validates the date from Form and saves email and password
  bool validateAndSave() {
    final form = formKey.currentState; //to use form
    if (form.validate()) {
      form.save(); //to get values of email and password, calls onSave methods
      return true;
    } 
    return false;
  }

  //vall this method while pressing the button
  //inside this method is another method which 
  //validates that password and email aren't empty
  void validateAndSubmit(){
    if (validateAndSave()){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: formKey, //connected with GlobalKey
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value.isEmpty ? ('Email can\'t be empty') : null,
                    onSaved: (value) => _email = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) =>
                        value.isEmpty ? ('Password can\'t be empty') : null,
                         onSaved: (value) => _password = value,
                  ),
                  RaisedButton(
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: validateAndSubmit,
                  ),
                ],
              ),
            )));
  }
}

// RaisedButton(
//   child: Text('Move to main screen'),
//   onPressed: () {
//     setState(() {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => MyHomePage()),
//       (Route<dynamic> route) => false);
//     });
//   },
// ),
