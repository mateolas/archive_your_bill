import 'package:flutter/material.dart';

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
              Container(
                color: Colors.blue,
                padding: EdgeInsets.all(15),
                child: Text('Logo'),
              ),
              Container(
                color: Colors.purple,
                padding: EdgeInsets.all(15),
                child: Text('Search'),
              ),
              Container(
                color: Colors.green,
                padding: EdgeInsets.all(15),
                child: Text('List of bills'),
              ),
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
