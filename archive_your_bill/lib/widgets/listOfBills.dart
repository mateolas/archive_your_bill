import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import '../models/bill.dart';

/////////////////////////////////////
//class draws the ListView of bills//
/////////////////////////////////////

class ListOfBills extends StatelessWidget {
  final List<Bill> bills;
  final Function deleteBill;

  ListOfBills(this.bills, this.deleteBill);

  final formatCurrency = new NumberFormat.compactSimpleCurrency();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: bills.isEmpty
          ? Column(
              children: <Widget>[
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 200,
                  child: Text('Picture to be added'),
                  //Image.asset(
                  //'assets/images/waiting.png',
                  //fit: BoxFit.cover,
                ),
              ],
            )
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
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
                          Container(
                              padding: EdgeInsets.all(6),
                              child: Text('${bills[index].itemCategory}')),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  '${bills[index].shopName}',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text('${bills[index].itemName}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                        '${formatCurrency.format(bills[index].itemCost)}'),
                                  ),
                                ],
                              ),

                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                    '${'Warranty until: '} ${DateFormat.yMMMd().format(bills[index].warrantyUntil)}'),
                              ),
                              //Text(
                              //  DateFormat.yMMMd().format(bills[index].purchaseDate),
                              //),
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
                                      onPressed: () =>
                                          deleteBill(bills[index].id),
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
              itemCount: bills.length,
            ),
    );
  }
}
