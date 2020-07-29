import 'package:archive_your_bill/widgets/auth.dart';
import 'package:flutter/material.dart';

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
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      body: ListView.separated(
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: Colors.black,
        ),
        itemBuilder: (_, index) {
          return ListTile(
            title: Text('Hello'),
            subtitle: Text('Last edited on 21/2/2021'),
          );
        },
        itemCount: 30,
      ),
    );
  }
}
