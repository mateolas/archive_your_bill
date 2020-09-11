import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/model/bill.dart';
import 'package:intl/intl.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';

class BillDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);

    _onBillDeleted(Bill bill) {
      Navigator.pop(context);
      billNotifier.deleteBill(bill);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(billNotifier.currentBill.nameShop),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Image.network(
                    billNotifier.currentBill.image != null
                        ? billNotifier.currentBill.image
                        : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    fit: BoxFit.fitWidth,
                  ),
                  SizedBox(height: 24),
                  //SHOP NAME
                  Text(
                    billNotifier.currentBill.nameShop,
                    style: TextStyle(
                      fontSize: 32,
                    ),
                  ),
                  //ITEM NAME
                  Text(
                    '${billNotifier.currentBill.nameItem}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Text('Category: ${billNotifier.currentBill.category}',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.left),
                ),
                SizedBox(height: 10),
                //PRICE AND CURRENCY
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Container(
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Item price: ${billNotifier.currentBill.priceItem}',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          ' ${billNotifier.currentBill.currencyItem}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                //BOUGHT
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Text(
                    'Bought: ${DateFormat.yMMMd().format(billNotifier.currentBill.warrantyStart.toDate())}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                //WARRANTY UNTIL
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Text(
                    'Warranty until: ${DateFormat.yMMMd().format(billNotifier.currentBill.warrantyEnd.toDate())}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                //WARRANTY LENGTH
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: Text(
                    'Warranty length: ${billNotifier.currentBill.warrantyLength} months',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return BillForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () =>
                deleteBill(billNotifier.currentBill, _onBillDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
