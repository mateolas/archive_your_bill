import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/screens/detail.dart';

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
            return Icon(Icons.computer);
          }
          break;

        case "Fashion":
          {
            return Icon(Icons.local_offer);
          }
          break;

        case "Sports":
          {
            return Icon(Icons.fitness_center);
          }
          break;

        case "Home":
          {
            return Icon(Icons.home);
          }
          break;

        case "Food":
          {
            return Icon(Icons.local_dining);
          }
          break;

        case "Health":
          {
            return Icon(Icons.local_hospital);
          }
          break;

        case "Services":
          {
            return Icon(Icons.build);
          }
          break;

        case "Other":
          {
            return Icon(Icons.receipt);
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
        //TO-DO: Custom Tile
        //link to custom ListView
        //https://stackoverflow.com/questions/46416024/proper-way-to-add-gesturedector-to-listview-builder-card-in-flutter
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                billNotifier.currentBill = billNotifier.billList[index];
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => FoodDetail()))
                    .then((value) {
                  setState(() {
                    _refreshList();
                  });
                });
              },
              child: Card(
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
                            child: categoryToIcon(billNotifier.billList[index].category)),
                        //Item name and cost
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${billNotifier.billList[index].nameShop}'),
                            Text('${billNotifier.billList[index].nameItem}'),
                            Text('${3}'),
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
                                    onPressed: () => {},
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

            // return ListTile(
            //   leading: categoryToIcon(billNotifier.billList[index].category),
            //   //  Image.network(
            //   //   foodNotifier.foodList[index].image != null
            //   //       ? foodNotifier.foodList[index].image
            //   //       : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
            //   //   width: 120,
            //   //   fit: BoxFit.fitWidth,
            //   // ),
            //   title: Text(billNotifier.billList[index].nameShop),
            //   subtitle: Text(billNotifier.billList[index].category),
            //   onTap: () {
            //     billNotifier.currentBill = billNotifier.billList[index];
            //     Navigator.push(
            //                     context,
            //                     MaterialPageRoute(
            //                         builder: (context) => FoodDetail()))
            //                 .then((value) {
            //               setState(() {
            //                 _refreshList();
            //               });
            //             });

            //   },
            // );
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
