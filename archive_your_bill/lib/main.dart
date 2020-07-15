import 'package:archive_your_bill/widgets/listOfBills.dart';
import 'package:flutter/material.dart';

import './models/bill.dart';
import './widgets/newBill.dart';

void main() {
  runApp(MyApp());
}

//class which is the main widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.white,
        hintColor: Colors.grey,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: Colors.grey,
          ),
          labelStyle: TextStyle(
            color: Colors.blue,
          ),
        ),
      ),
      title: 'Archive your bill',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  //function which add new bill
  void addNewBill(
    String newId,
    String newShopName,
    String newName,
    String newType,
    double newCost,
    int newWarrantyLengthMonths,
  ) {
    final newBill = Bill(
      id: newId,
      shopName: newShopName,
      itemName: newName,
      itemType: newType,
      itemCost: newCost,
      itemWarrantyLengthMonths: newWarrantyLengthMonths,
      purchaseDate: DateTime.now(),
      warrantyUntil: DateTime.now(),
    );
  }

  //function which builds a screen using NewBill widget
  void startAddNewBill(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (BuildContext ctx) {
          return NewBill(addNewBill);
        }
        // showModalBottomSheet(
        //   context: ctx,
        //   builder: (_) {
        //     return GestureDetector(
        //       onTap: () {},
        //       child: NewBill(
        //         addNewBill,
        //       ),
        //       behavior: HitTestBehavior.opaque,
        //     );
        //   },
        // );
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[300],
        title: Text('Archive your bill'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
          )
        ],
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
            //ListView wrapped in Container
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(
          vertical: 25,
          horizontal: 15,
        ),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => startAddNewBill(context),
        ),
      ),
    );
  }
}
