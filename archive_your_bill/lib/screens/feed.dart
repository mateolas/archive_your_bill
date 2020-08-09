import 'package:archive_your_bill/api/food_api.dart';
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
  //turn class into statefull to use initState
  //it enables us to get list of Bills during loading of the app
  void initState() {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    getBills(billNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //notifiers
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    // we want to listen to changes, so not setting listen to false
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);

    print("building Feed");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //showing the 'Display name' at the top of the screen
          authNotifier.user != null ? authNotifier.user.displayName : "Feed",
        ),
        actions: <Widget>[
          // action button
          FlatButton(
            onPressed: () => signout(authNotifier),
            child: Text(
              "Logout",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ],
      ),
      //listView to present the data from Firebase
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            //adding image from firebase
            leading: Image.network(
              billNotifier.billList[index].image,
              width: 80,
              fit: BoxFit.fitWidth,
            ),
            title: Text(billNotifier.billList[index].name),
            subtitle: Text(billNotifier.billList[index].category),
            //when we tap on the Tile of the listView we're moving to a screen
            //where we're presenting the current bill
            onTap: () {
              billNotifier.currentBill = billNotifier.billList[index];
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return BillDetail();
              }));
            },
          );
        },
        itemCount: billNotifier.billList.length,
        separatorBuilder: (BuildContext context, int index) {
          //returning separator, we can have image/text or divider for example
          return Divider(color: Colors.black);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //when we're pressing 'Add new bill' we're setting the currentBill to null
          //thanks to it, we're starting a newBill and not editing a bill
          billNotifier.currentBill = null;
          //moving into bill_form page
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            //isUpdating parameter: to know are we updating or editing
            return BillForm(isUpdating: false);
          }));
        },
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
      ),
    );
  }
}
