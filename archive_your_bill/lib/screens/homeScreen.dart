// import 'package:flutter/material.dart';
// import 'package:archive_your_bill/widgets/auth.dart';

// import 'package:archive_your_bill/widgets/listOfBills.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../models/bill.dart';
// import '../widgets/newBill.dart';
// import '../screens/rootScreen.dart';
// import 'package:archive_your_bill/widgets/auth.dart';

// class HomeScreen extends StatefulWidget {
//   HomeScreen({this.auth, this.onSignedOut});

//   final BaseAuth auth;
//   final VoidCallback onSignedOut;

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   void _signOut() async {
//     try {
//       await widget.auth.signOut();
//       widget.onSignedOut();
//     } catch (e) {
//       print(e);
//     }
//   }


// list of userBills
//   List<Bill> userBills = [
//     Bill(
//       id: 'b1',
//       shopName: 'Media Markt',
//       itemName: 'PC',
//       itemCategory: 'Electronics',
//       itemCost: 5000,
//       purchaseDate: DateTime.now(),
//       itemWarrantyLengthMonths: 12,
//       warrantyUntil: DateTime.now(),
//     ),
//   ];

//   functions which adds new bill
//   as paramater gets name, type, cost etc. and based on them creates new Bill object
//   void addNewBill(String newShopName, String newName, double newCost,
//       String newCategory, DateTime newWarrantyUntil) {
//     new Bill object
//     final newBill = Bill(
//         shopName: newShopName,
        
//         billID: DateTime.now().toString());

//     updating the State
//     adding newBill object to list of existing bills
//     setState(
//       () {
//         userBills.add(newBill);
//       },
//     );
//   }

//   void deleteBill(String id) {
//     setState(() {
//       userBills.removeWhere((element) => element.billID == id);
//     });
//   }

//   function which builds a screen using NewBill widget
//   returns NewBill object with needs have three parameters as input
//   void startAddNewBill(BuildContext ctx) {
//     showModalBottomSheet(
//       context: ctx,
//       isScrollControlled: true,
//       builder: (BuildContext ctx) {
//         return NewBill(addNewBill);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Archive your bill'),
//         actions: <Widget>[
//             FlatButton(
//               child: Text('Logout'),
//               onPressed: _signOut,
//             ),
//           ],
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             Logo
//             Container(
//               color: Colors.blue,
//               padding: EdgeInsets.all(15),
//               child: Text('Logo'),
//             ),
//             Search
//             Container(
//               color: Colors.purple,
//               padding: EdgeInsets.all(15),
//               child: Text('Search'),
//             ),
//             ListView wrapped in Container
//             Container(
//               height: 400,
//               child: ListOfBills(userBills, deleteBill),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
//       floatingActionButton: Container(
//         padding: EdgeInsets.symmetric(
//           vertical: 25,
//           horizontal: 15,
//         ),
//         child: FloatingActionButton(
//           child: Icon(Icons.add),
//           onPressed: () => startAddNewBill(context),
//         ),
//       ),
//     );
//   }
// }
