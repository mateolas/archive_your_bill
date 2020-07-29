import 'package:archive_your_bill/views/bill_delete.dart';
import 'package:archive_your_bill/views/bill_modify.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:archive_your_bill/widgets/auth.dart';
import 'package:archive_your_bill/models/bill.dart';

class BillList extends StatelessWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  BillList({this.auth, this.onSignedOut});

  void _signOut() async {
    try {
      await auth.signOut();
      onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  final bills = [
    Bill(
      billID: '1',
      shopName: 'Note 1',
      purchaseDate: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),
    Bill(
      billID: '2',
      shopName: 'Note 2',
      purchaseDate: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),
    Bill(
      billID: '3',
      shopName: 'Note 3',
      purchaseDate: DateTime.now(),
      latestEditDateTime: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archive your bill'),
        actions: <Widget>[
          FlatButton(
            child: Text('Logout'),
            onPressed: _signOut,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        //Navigator takes user to the page to Add/Edit Bill
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => BillModify()));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (_, index) {
          return Dismissible(
            //need to provide unique value
            key: ValueKey(bills[index].billID),
            direction: DismissDirection.startToEnd,
            //triggers when user tries to dismiss, when say yes we're executing onDismiss
            onDismissed: (direction) {},
            //triggers when user tries to dismiss
            //we need to collect the result of Yes/No
            //show dialog is a future so we need to await / async this
            confirmDismiss: (direction) async {
              final result = await showDialog(
                context: context,
                builder: (_) => BillDelete(),
              );
              return result;
            },
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.only(left: 16),
              child: Align(
                child: Icon(Icons.delete, color: Colors.white),
                alignment: Alignment.centerLeft,
              ),
            ),
            child: ListTile(
              title: Text(
                  //name of the shop from the bills list
                  //index supplied by Flutter
                  bills[index].shopName),
              subtitle: Text(
                  'Last edited on ${DateFormat.yMMMd().format(bills[index].latestEditDateTime)}'),
              //exclusive method of ListTile ;)
              //after taping we're going to page to modify the bill
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BillModify(
                        billID: bills[index]
                            .billID))); //passing an ID to know is it New or Modify
              },
            ),
          );
        },
        //length of the list which we want to present
        itemCount: bills.length,
      ),
    );
  }
}
