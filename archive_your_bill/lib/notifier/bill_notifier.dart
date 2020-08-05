import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:archive_your_bill/model/bill.dart';


class BillNotifier with ChangeNotifier{
  //our list of bills
  List<Bill> _billList = [];
  //to track current bill
  Bill _currentBill;

  //gets the bill list and and make sure that we can't change it when we get from our notifier
  UnmodifiableListView<Bill> get billList => UnmodifiableListView(_billList);

  Bill get currentBill => _currentBill;

  //when we call app for the first time we want to call this setter
  //to set a bill list
  set billList(List<Bill> billList){
    _billList = billList;
    notifyListeners();
  }

  //when we change a current bill, we're calling this setter
  set currentBill(Bill bill){
    _currentBill = bill;
    notifyListeners();
  }
}