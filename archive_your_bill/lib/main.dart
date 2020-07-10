import 'package:archive_your_bill/widgets/listOfBills.dart';
import 'package:flutter/material.dart';

import './models/bill.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Archive your bill',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Archive your bill'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              //Logo
              Container(
                color: Colors.blue,
                padding: EdgeInsets.all(15),
                child: Text('Logo'),
              ),
              //Search
              Container(
                color: Colors.purple,
                padding: EdgeInsets.all(15),
                child: Text('Search'),
              ),
              //ListView
              Container(
                height: 100,
                child: ListOfBills(),
              ),
              //AddButton
              Container(
                color: Colors.yellow,
                padding: EdgeInsets.all(15),
                child: Text('Add button'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
