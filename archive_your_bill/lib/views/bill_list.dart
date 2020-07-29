import 'package:archive_your_bill/services/bills_service.dart';
import 'package:archive_your_bill/views/bill_delete.dart';
import 'package:archive_your_bill/views/bill_modify.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:intl/intl.dart';
import 'package:archive_your_bill/widgets/auth.dart';
import 'package:archive_your_bill/models/bill.dart';

class BillList extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  BillList({this.auth, this.onSignedOut});

  @override
  _BillListState createState() => _BillListState();
}

class _BillListState extends State<BillList> {
  BillsService get service => GetIt.I<BillsService>();
  List<Bill> bills = [];

   //service is a source of data 
  //bill list doesn't care is it from API / database or whatever :P :D
   //method called when we're opening stateful page
  @override
  void initState() {
    bills = service.getBillsList();
    super.initState();
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

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
