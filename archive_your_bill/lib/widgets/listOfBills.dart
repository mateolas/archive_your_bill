import "package:flutter/material.dart";
import '../models/bill.dart';

/////////////////////////////////////
//class draws the ListView of bills//
/////////////////////////////////////

class ListOfBills extends StatelessWidget {
  final List<Bill> bills;
  Function deleteBill;
  
  ListOfBills(this.bills,this.deleteBill);

  

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: bills.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.all(6),
          shadowColor: Colors.yellow,
          color: Colors.white,
          child: Container(
            height: 100,
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
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.share),
                              color: Colors.grey,
                              onPressed: () {},
                            ),
                          ),
                          Container(
                            
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              disabledColor: Colors.yellow,
                              color: Colors.grey,
                              onPressed: () => deleteBill(bills[index].id),
                            ),
                          ),
                        ],
                      ),
                    ),
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
