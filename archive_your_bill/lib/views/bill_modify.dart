import 'package:flutter/material.dart';

class BillModify extends StatelessWidget {
  //when billID is null we're creating a new Bill
  //when billID is not null, we're fetching data/editing already existing bill
  //when editing the bill we're changing the app bar title to "Modify"
  //to make more readable we're creating a getter
  final String billID;

  //is the billID empty or not
  //useful in future to determine are we adding or modifing API item
  bool get isEditing => billID != null;

  BillModify({this.billID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //if noteID is null we're creating a Bill
      //if noteID isn't null we're modifing a Bill
      appBar: AppBar(title: Text(isEditing ? 'Edit Bill' : 'Create Bill')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Shop name',
              ),
            ),
            Container(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Shop name',
              ),
            ),

            Container(height: 8),

            //using SizedBox to expand width of the button for whole screen
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                  child: Text('Submit'),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (isEditing) {
                      //update bill in api
                    } else {
                      //create bill in api
                    }

                    //closes the window
                    Navigator.of(context).pop();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
