import 'package:flutter/material.dart';
import 'package:archive_your_bill/widgets/auth.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({this.auth, this.onSignedOut});

  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
          actions: <Widget>[
            FlatButton(
              child: Text('Logout'),
              onPressed: _signOut,
            ),
          ],
        ),
        body: Container(
          child: Center(
              child: Text(
            'Welcome',
            style: TextStyle(
              fontSize: 32.0,
            ),
          )),
        ));
  }
}