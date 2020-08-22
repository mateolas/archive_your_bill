import 'package:archive_your_bill/api/food_api.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/screens/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: false);
    getFoods(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: true);
    FoodNotifier foodNotifier =
        Provider.of<FoodNotifier>(context, listen: true);

    Future<void> _refreshList() async {
      getFoods(foodNotifier);
    }

    Stream<QuerySnapshot> getBillsStreamSnapshots(BuildContext context) async* {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final FirebaseUser user = await auth.currentUser();
      final uid = user.uid;
      
    
      yield* Firestore.instance
          .collection('userData')
          .document(uid.toString())
          .collection('bills')
          .snapshots();
      print('Uid: $uid');
    }

    print("building Feed");
    print('First authnotifier ${authNotifier.user.displayName}');

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
        child: StreamBuilder(
            stream: getBillsStreamSnapshots(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text("Loading...");
              } else {
                return ListView.separated(
                  itemCount: foodNotifier.foodList.length,
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
                      //title: Text(snapshot.data.documents[index].name),
                      //subtitle: Text(snapshot.data.documents[index].category),
                      title: Text(foodNotifier.foodList[index].name),
                      subtitle: Text(foodNotifier.foodList[index].category),
                      onTap: () {
                        foodNotifier.currentFood =
                            foodNotifier.foodList[index];
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return FoodDetail();
                        }));
                      },
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      color: Colors.black,
                    );
                  },
                );
              }
            }),
        onRefresh: _refreshList,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          foodNotifier.currentFood = null;
          Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) {
              return FoodForm(
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
