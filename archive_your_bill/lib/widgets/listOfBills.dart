import "package:flutter/material.dart";
import '../models/bill.dart';

/////////////////////////////////////
//class draws the ListView of bills//
/////////////////////////////////////

class ListOfBills extends StatelessWidget {
  final List<Bill> bills;
  
  ListOfBills(this.bills);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: bills.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          shadowColor: Colors.yellow,
          color: Colors.white,
          child: Container(
            //color: Colors.grey,
            height: 80,
            child: Center(
              child: Row(
                children: <Widget>[
                  //Shop name
                  Container(
                      padding: EdgeInsets.all(10),
                      //color: Colors.blue,
                      child: Text('${bills[index].shopName}')),
                  //Item name and cost
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${bills[index].itemName}'),
                      Text('${bills[index].itemCost}'),
                      Text('${bills[index].purchaseDate}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
