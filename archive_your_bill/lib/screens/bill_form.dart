import 'package:flutter/material.dart';

class BillForm extends StatefulWidget {
  @override
  _BillFormState createState() => _BillFormState();
}

class _BillFormState extends State<BillForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill form'),
      ),
      body: Text("Bill Form"),
    );
  }
}
