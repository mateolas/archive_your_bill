import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/screens/detail.dart';
import 'package:intl/intl.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    getBills(billNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);

    Future<void> _refreshList() async {
      getBills(billNotifier);
    }

    print("building Feed");
    print('First authnotifier ${authNotifier.user.displayName}');

    categoryToIcon(String category) {
      switch (category) {
        case "Electronics":
          {
            return Icon(Icons.computer, size: 32);
          }
          break;

        case "Fashion":
          {
            return Icon(Icons.local_offer, size: 32);
          }
          break;

        case "Sports":
          {
            return Icon(Icons.fitness_center, size: 32);
          }
          break;

        case "Home":
          {
            return Icon(Icons.home, size: 32);
          }
          break;

        case "Food":
          {
            return Icon(Icons.local_dining, size: 32);
          }
          break;

        case "Health":
          {
            return Icon(Icons.local_hospital, size: 32);
          }
          break;

        case "Services":
          {
            return Icon(Icons.build, size: 32);
          }
          break;

        case "Other":
          {
            return Icon(Icons.receipt, size: 32);
          }
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        //added display.name
        title: Text(authNotifier.user.displayName != null
            ? authNotifier.user.displayName
            : "Main page"),
        actions: <Widget>[
          // action button - logout
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ),
        ],
      ),
      body: new RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                //after clicking setting up with notifier a current bill
                billNotifier.currentBill = billNotifier.billList[index];
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BillDetail()))
                    .then((value) {
                  setState(() {
                    _refreshList();
                  });
                });
              },
              child: Card(
                elevation: 3,
                margin: EdgeInsets.all(6),
                shadowColor: Colors.black,
                color: Colors.white,
                child: Container(
                  height: 140,
                  child: Center(
                    child: Row(
                      children: <Widget>[
                        //Category Icon
                        Container(
                            padding: EdgeInsets.all(10),
                            //color: Colors.blue,
                            child: categoryToIcon(
                                billNotifier.billList[index].category)),
                        //Item name and cost
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //SHOP NAME
                            Text(
                              '${billNotifier.billList[index].nameShop}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 6)),
                            //ITEM NAME
                            Text(
                              '${billNotifier.billList[index].nameItem}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 12)),
                            //ITEM PRICE AND CURRENCY
                            Row(
                              children: [
                                Text(
                                    'Price: ${billNotifier.billList[index].priceItem}',
                                    style: TextStyle(fontSize: 14)),
                                Text(
                                    ' ${billNotifier.billList[index].currencyItem}',
                                    style: TextStyle(fontSize: 14)),
                              ],
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4)),
                            //ITEM BOUGHT DATE
                            Text(
                              'Bought: ${DateFormat.yMMMd().format(billNotifier.billList[index].warrantyStart.toDate())}',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4)),
                            //WARRANTY UNTIL
                            billNotifier.billList[index].warrantyEnd == null
                                ? ''
                                : Text(
                                    'Warranty until: ${DateFormat.yMMMd().format(billNotifier.billList[index].warrantyEnd.toDate())}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
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
                                    icon: Icon(Icons.edit),
                                    color: Colors.grey,
                                    onPressed: () {
                                      billNotifier.currentBill = billNotifier.billList[index];
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) {
                                          return BillForm(
                                            isUpdating: true,
                                          );
                                        }),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  child: IconButton(
                                    icon: Icon(Icons.share),
                                    disabledColor: Colors.yellow,
                                    color: Colors.grey,
                                    onPressed: () {},
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
              ),
            );
          },
          itemCount: billNotifier.billList.length,
        ),
        onRefresh: _refreshList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          billNotifier.currentBill = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return BillForm(
                isUpdating: false,
              );
            }),
          );
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}
