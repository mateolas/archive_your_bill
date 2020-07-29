import 'package:archive_your_bill/views/bill_list.dart';
import 'package:flutter/material.dart';

import 'package:archive_your_bill/screens/loginScreen.dart';
import 'package:archive_your_bill/widgets/auth.dart';
import 'package:archive_your_bill/screens/homeScreen.dart';

class RootScreen extends StatefulWidget {
  final BaseAuth auth;

  RootScreen({this.auth});
  
  @override
  _RootScreenState createState() => _RootScreenState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootScreenState extends State<RootScreen> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  //method is called every time the stateful widget is created
  //opportunity to define initial state
  //good moment to check for current user
  //because we implemeneted initState we will have Home screen
  //even after minimizing the app
  @override
  void initState() {
    super.initState();
    //currentUser returns value only when user logged succesfully
    widget.auth.currentUser().then((userId) {
      setState(() {
        //authStatus =
        //userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginScreen(
          //defining authentication provider
          auth: widget.auth,
          //LoginScreen providing a signedIn callback
          onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return BillList(
          auth: widget.auth,
          onSignedOut: _signedOut,
        );
    }
  }
}
