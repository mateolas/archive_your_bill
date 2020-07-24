import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:archive_your_bill/main.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum FormType { login, register }

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>(); //to use form

  String _email;
  String _password;
  FormType _formType = FormType.login;

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
  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        if (_formType == FormType.login) { //in case we're login in
          FirebaseUser user = (await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: _email, password: _password))
              .user;
          print('Signed in: ${user.uid}');
        } else { //in case we're registering user
          FirebaseUser user = (await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: _email, password: _password))
              .user;
          print('Registered user: ${user.uid}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    //to remove any typed data from previous screen
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    //to remove any typed data from previous screen
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
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
            children: buildInputs() + buildSubmitButtons(),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? ('Email can\'t be empty') : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) =>
            value.isEmpty ? ('Password can\'t be empty') : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text(
            'Login',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'Create an account',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToRegister,
        )
      ];
    } else {
      return [
        RaisedButton(
          child: Text(
            'Create an account',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text(
            'Have an account ? Login',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
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
