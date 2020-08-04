import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:provider/provider.dart';

import './screens/feed.dart';
import './screens/login.dart';
import 'package:flutter/material.dart';

import 'notifier/auth_notifier.dart';

void main() => runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (context) => AuthNotifier(),
        ),
        ChangeNotifierProvider(
          builder: (context) => BillNotifier(),
        )
      ],
      child: MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding with Curry',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.blue,
      ),
      //consumer for provider type of Notifier
      //reacts when user is changed
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          //if firebase user changes in this notifier, this get rebuild
          //if user is already logged in it will be Feed
          //if user is not logged it will show Logged
          return notifier.user != null ? Feed() : Login();
        },
      ),
    );
  }
}
