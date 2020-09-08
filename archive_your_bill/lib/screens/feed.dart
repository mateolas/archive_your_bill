import 'package:archive_your_bill/api/bill_api.dart';
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
    BillNotifier foodNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    getBills(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    BillNotifier foodNotifier = Provider.of<BillNotifier>(context);

    Future<void> _refreshList() async {
      getBills(foodNotifier);
    }

    print("building Feed");
    print('First authnotifier ${authNotifier.user.displayName}');

    return Scaffold(
      appBar: AppBar(
        //added display.name
        title: Text(authNotifier.user.displayName != null ?  authNotifier.user.displayName : "Main page" ),
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
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Text('Test'),
              //  Image.network(
              //   foodNotifier.foodList[index].image != null
              //       ? foodNotifier.foodList[index].image
              //       : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
              //   width: 120,
              //   fit: BoxFit.fitWidth,
              // ),
              title: Text(foodNotifier.billList[index].name),
              subtitle: Text(foodNotifier.billList[index].category),
              onTap: () {
                foodNotifier.currentBill = foodNotifier.billList[index];
                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FoodDetail()))
                            .then((value) {
                          setState(() {
                            _refreshList();
                          });
                        });

              },
            );
          },
          itemCount: foodNotifier.billList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
        ),
        onRefresh: _refreshList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          foodNotifier.currentBill = null;
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