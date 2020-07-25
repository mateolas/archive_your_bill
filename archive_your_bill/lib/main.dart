import 'package:flutter/material.dart';

import './screens/rootScreen.dart';
import 'package:archive_your_bill/widgets/auth.dart';

void main() {
  runApp(MyApp());
}

//class which is the main widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        accentColor: Colors.black,
        hintColor: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          labelStyle: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      title: 'Archive your bill',
      home: RootScreen(
        auth: Auth(),
      ),
    );
  }
}

