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
        body: Center(
          child: Column(
            children: <Widget>[Text('Details')],
          ),
        ));
  }
}
