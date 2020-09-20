import 'package:archive_your_bill/api/bill_api.dart';
import 'package:archive_your_bill/model/bill.dart';
import 'package:archive_your_bill/notifier/auth_notifier.dart';
import 'package:archive_your_bill/notifier/bill_notifier.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/screens/detail.dart';
import 'package:intl/intl.dart';

import 'dart:async';
import 'dart:io';
import 'package:share/share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  TextEditingController _searchController = TextEditingController();
  List _resultsList = [];

  @override
  void initState() {
    BillNotifier billNotifier =
        Provider.of<BillNotifier>(context, listen: false);
    getBills(billNotifier);
    super.initState();
    _searchController.addListener(_onSearchChanged);
    //setSearchResultsList(billNotifier);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged());
    _searchController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    BillNotifier billNotifier = Provider.of<BillNotifier>(context, listen: false);
    setSearchResultsList(billNotifier);
    //print(_searchController.text);
  }

  //function wcich creates a second filtered list
  //bill notifier as a argument to get the list of the bills
  setSearchResultsList(billNotifier) {
    //list were filtered values will be kept
    var showResults = [];

    //if text field is not empty
    if (_searchController.text != "") {
    //search whole list from firebase
      for (var bill in billNotifier.billList) {
        var title = bill.nameShop.toLowerCase();
        var title2 = bill.nameItem.toLowerCase();
    //if typed by user value equals bill's nameShop or nameItem add bill to the filtered list - showResults
        if (title.contains(_searchController.text.toLowerCase()) || title2.contains(_searchController.text.toLowerCase())  ) {
          showResults.add(bill);
        }
      }
    //if text field is empty copy all the items from list fetched from firebase to filtered list
    } else {
      showResults = billNotifier.billList;
    }
    //update the results
    setState(() {
      _resultsList = showResults;
    });
  }

  //Search field widget
  Widget searchField() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: new OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }

  //function which draws Icon based on the chosen by user category
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
        text: 'Hey! Checkout the Share Files repo',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }


  //function to refresh the screen
  @override
  void didChangeDependencies() {
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);
    super.didChangeDependencies();
    setState(() {
      getBills(billNotifier);
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    BillNotifier billNotifier = Provider.of<BillNotifier>(context);
    //function to used in RefreshIndicator widhget
    //swipe to refresh
    Future<void> _refreshList() async {
      getBills(billNotifier);
      setSearchResultsList(billNotifier);
    }

    //sets the search results
    setSearchResultsList(billNotifier);

    print("1 Building Feed");
    print('2 First authnotifier ${authNotifier.user.displayName}');
    print("3 BUILD RESULT LIST LENGTH: ${_resultsList.length}");

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
      body: Column(
        children: [
          searchField(),
          Expanded(
            child: RefreshIndicator(
                          child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      //after clicking setting up with notifier a current bill
                      billNotifier.currentBill = _resultsList[index];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BillDetail())).then((value) {
                      
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
                                      _resultsList[index].category)),
                              //Item name and cost
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  //SHOP NAME
                                  Text(
                                    '${_resultsList[index].nameShop}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 6)),
                                  //ITEM NAME
                                  Text(
                                    '${_resultsList[index].nameItem}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 12)),
                                  //ITEM PRICE AND CURRENCY
                                  Row(
                                    children: [
                                      Text(
                                          'Price: ${_resultsList[index].priceItem}',
                                          style: TextStyle(fontSize: 14)),
                                      Text(' ${_resultsList[index].currencyItem}',
                                          style: TextStyle(fontSize: 14)),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 4)),
                                  //ITEM BOUGHT DATE
                                  Text(
                                    'Bought: ${DateFormat.yMMMd().format(_resultsList[index].warrantyStart.toDate())}',
                                    style: TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 4)),
                                  //WARRANTY UNTIL
                                  billNotifier.billList[index].warrantyEnd == null
                                      ? ''
                                      : Text(
                                          'Warranty until: ${DateFormat.yMMMd().format(_resultsList[index].warrantyEnd.toDate())}',
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
                                            billNotifier.currentBill =
                                                _resultsList[index];
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
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
                                          onPressed: () {
                                            billNotifier.currentBill =
                                                _resultsList[index];

                                            saveAndShare(
                                                nameShop:
                                                    _resultsList[index].nameShop,
                                                nameItem:
                                                    _resultsList[index].nameItem,
                                                itemPrice:
                                                    _resultsList[index].priceItem,
                                                warrantyStart: DateFormat.yMMMd()
                                                    .format(_resultsList[index]
                                                        .warrantyStart
                                                        .toDate()),
                                                warrantyEnd: DateFormat.yMMMd()
                                                    .format(_resultsList[index]
                                                        .warrantyEnd
                                                        .toDate()),
                                                warrantyLength:
                                                    _resultsList[index]
                                                        .warrantyLength,
                                                url: _resultsList[index].image);
                                          },
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
                itemCount: _resultsList.length,
              ),
              onRefresh: _refreshList,
            ),
          ),
        ],
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
