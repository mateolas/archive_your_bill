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
    BillNotifier foodNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    getBills(foodNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);

    Bill _currentBill;

    Future<void> _refreshList() async {
      getBills(billNotifier);
    }

    print("building Feed");
    print('First authnotifier ${authNotifier.user.displayName}');

    categoryToIcon(String category){
      switch(category) { 
      case "Electronics": { return Icon(Icons.computer); } 
      break; 
     
      case "Fashion": {  return Icon(Icons.local_offer); } 
      break; 
     
      case "Sports": {  return Icon(Icons.fitness_center); } 
      break; 

      case "Home": {  return Icon(Icons.home); } 
      break; 

      case "Food": {  return Icon(Icons.local_dining); } 
      break; 

      case "Health": {  return Icon(Icons.local_hospital); } 
      break; 

      case "Services": {  return Icon(Icons.build); } 
      break; 

      case "Other": {  return Icon(Icons.receipt); } 
      break;  
    
   }  
    }

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
              leading: categoryToIcon(billNotifier.billList[index].category),
              //  Image.network(
              //   foodNotifier.foodList[index].image != null
              //       ? foodNotifier.foodList[index].image
              //       : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
              //   width: 120,
              //   fit: BoxFit.fitWidth,
              // ),
              title: Text(billNotifier.billList[index].nameShop),
              subtitle: Text(billNotifier.billList[index].category),
              onTap: () {
                billNotifier.currentBill = billNotifier.billList[index];
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
          itemCount: billNotifier.billList.length,
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