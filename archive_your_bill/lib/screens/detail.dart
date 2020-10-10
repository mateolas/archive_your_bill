import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/model/bill.dart';
import 'package:intl/intl.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'only_image_screen.dart';

import 'dart:io';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);

    void printVariable(BillNotifier bill){
      print(bill);
    }

    _onBillDeleted(Bill bill) {
      Navigator.pop(context);
      billNotifier.deleteBill(bill);
    }

    //function to get image from url, save it and share
    Future<Null> saveAndShare(
        {String url,
        String nameShop,
        String nameItem,
        String category,
        String itemPrice,
        String warrantyStart,
        String warrantyEnd,
        String warrantyLength}) async {
      //enable permission to write/read from internal memory
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }

      if(billNotifier.currentBill.image == null){
        url = "https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg";
      }

      final RenderBox box = context.findRenderObject();

      //list of imagePaths
      List<String> imagePaths = [];
      var response = await get(url);
      //get the directory of external storage
      final documentDirectory = (await getExternalStorageDirectory()).path;
      //create empty file
      File imgFile = new File('$documentDirectory/flutter.png');
      //"copy" file from url to created empty file
      imgFile.writeAsBytesSync(response.bodyBytes);
      //add to list of paths path of created file
      imagePaths.add(imgFile.path);
      //share function
      Share.shareFiles(imagePaths,
          subject: 'Bill from ${nameShop} bought at ${warrantyStart}',
          text: 'Hey! Just sending you a picture of a bill from ${nameShop} where ${warrantyStart} you bought ${nameItem}. Have a great day ! Archive Your Bill Team',
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }

    showAlertDialog(BuildContext context) {
      // set up the buttons
      Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      Widget continueButton = FlatButton(
        child: Text("Yes"),
        onPressed: () {
          Navigator.pop(context);
          deleteBill(billNotifier.currentBill, _onBillDeleted);
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Delete Bill"),
        content: Text("Would you like to delete this bill ? (no undo)"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
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
                  GestureDetector(
                      child: Image.network(
                        billNotifier.currentBill.image != null
                            ? billNotifier.currentBill.image
                            : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                        width: MediaQuery.of(context).size.width,
                        height: 250,
                        fit: BoxFit.fitWidth,
                      ),
                      onTap: () {
                        print("IMAGE STRING ${billNotifier.currentBill.image}");
                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return OnlyImageScreen(
                            url: billNotifier.currentBill.image,
                          );
                        }));
                      }),
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
                  child: billNotifier.currentBill.warrantyEnd == Timestamp.fromDate(DateTime.parse("1969-07-20 20:18:04Z"))
                      ? Text('')
                      : Text(
                          'Warranty until: ${DateFormat.yMMMd().format(billNotifier.currentBill.warrantyEnd.toDate())}',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
                SizedBox(height: 10),
                //WARRANTY LENGTH
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: billNotifier.currentBill.warrantyLength == '0'
                   ? Text('')
                   : Text(
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
          Container(
            height: 46.0,
            width: 46.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: 'button1',
                backgroundColor: Colors.orange,
                onPressed: () {
                  saveAndShare(
                      nameShop: billNotifier.currentBill.nameShop,
                      nameItem: billNotifier.currentBill.nameItem,
                      itemPrice: billNotifier.currentBill.priceItem,
                      warrantyStart: DateFormat.yMMMd().format(
                          billNotifier.currentBill.warrantyStart.toDate()),
                      warrantyEnd: DateFormat.yMMMd().format(
                          billNotifier.currentBill.warrantyEnd.toDate()),
                      warrantyLength: billNotifier.currentBill.warrantyLength,
                      url: billNotifier.currentBill.image);
                },
                child: Icon(Icons.share),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 46.0,
            width: 46.0,
            child: FittedBox(
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                heroTag: 'button2',
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
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 46.0,
            width: 46.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: 'button3',
                onPressed: () => showAlertDialog(context),
                //deleteBill(billNotifier.currentBill, _onBillDeleted),
                child: Icon(Icons.delete),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
