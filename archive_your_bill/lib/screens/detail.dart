import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/model/bill.dart';

import 'package:archive_your_bill/notifier/bill_notifier.dart';

class FoodDetail extends StatelessWidget {
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
        child: Center(
          child: Container(
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
                Text(
                  billNotifier.currentBill.nameShop,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Category: ${billNotifier.currentBill.category}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
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
