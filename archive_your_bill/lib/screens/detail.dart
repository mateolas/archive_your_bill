import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:archive_your_bill/notifier/bill_notifier.dart';

class BillDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          billNotifier.currentBill.name,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Image.network(billNotifier.currentBill.image),
                height: 150,
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                billNotifier.currentBill.name,
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              Text(
                billNotifier.currentBill.category,
                style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 32),
              GridView.count(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(8),
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                children: billNotifier.currentBill.subIngredients
                    .map((ingredient) => Card(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              ingredient,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return BillForm();
          }));
        },
        child: Icon(Icons.edit),
        foregroundColor: Colors.white,
      ),
    );
  }
}
