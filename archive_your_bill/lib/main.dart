import 'package:archive_your_bill/widgets/listOfBills.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './models/bill.dart';
import './widgets/newBill.dart';
import './screens/loginScreen.dart';
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

class MyHomePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  //list of userBills
  List<Bill> userBills = [
    // Bill(
    //   id: 'b1',
    //   shopName: 'Media Markt',
    //   itemName: 'PC',
    //   itemCategory: 'Electronics',
    //   itemCost: 5000,
    //   purchaseDate: DateTime.now(),
    //   itemWarrantyLengthMonths: 12,
    //   warrantyUntil: DateTime.now(),
    // ),
  ];

  //functions which adds new bill
  //as paramater gets name, type, cost etc. and based on them creates new Bill object
  void addNewBill(String newShopName, String newName, double newCost,
      String newCategory, DateTime newWarrantyUntil) {
    //new Bill object
    final newBill = Bill(
        shopName: newShopName,
        itemName: newName,
        itemCost: newCost,
        itemCategory: newCategory,
        warrantyUntil: newWarrantyUntil,
        id: DateTime.now().toString());

    //updating the State
    //adding newBill object to list of existing bills
    setState(
      () {
        userBills.add(newBill);
      },
    );
  }

  void deleteBill(String id) {
    setState(() {
      userBills.removeWhere((element) => element.id == id);
    });
  }

  //function which builds a screen using NewBill widget
  //returns NewBill object with needs have three parameters as input
  void startAddNewBill(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return NewBill(addNewBill);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              height: 400,
              child: ListOfBills(userBills, deleteBill),
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
