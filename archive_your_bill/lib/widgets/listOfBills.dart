import "package:flutter/material.dart";
import '../models/bill.dart';

class ListOfBills extends StatelessWidget {
  List<Bill> listOfBills = [
    Bill(
      id: 'b1',
      shopName: 'Media Markt',
      name: 'PC',
      type: 'Electronics',
      cost: 5000,
      purchaseDate: DateTime.now(),
      warrantyLengthMonths: 12,
      warrantyUntil: DateTime.now(),
    ),
    Bill(
      id: 'b2',
      shopName: 'Euro RTV',
      name: 'Watch',
      type: 'Electronics',
      cost: 400,
      purchaseDate: DateTime.now(),
      warrantyLengthMonths: 12,
      warrantyUntil: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: listOfBills.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          color: Colors.grey,
          height: 100,
          child: Center(
            child: Row(
              children: <Widget>[
                //Shop name
                Container(
                  padding: EdgeInsets.all(10),
                    color: Colors.blue,
                    child: Text('${listOfBills[index].shopName}')),
                //Item name and cost
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Item name: ${listOfBills[index].name}'),
                    Text('Cost: ${listOfBills[index].cost}'),
                    Text('Cost: ${listOfBills[index].purchaseDate}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
