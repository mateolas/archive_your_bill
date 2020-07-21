import "package:flutter/material.dart";
import 'package:intl/intl.dart';

import 'package:archive_your_bill/widgets/itemCategoryMenu.dart';
import 'package:archive_your_bill/widgets/photoPreview.dart';

//Class which draws the layout of the New Bill screen
//In constructor has a function which is called to pass submitted data

class NewBill extends StatefulWidget {
  Function addNewBill;

  NewBill(this.addNewBill);

  @override
  _NewBillState createState() => _NewBillState();
}

class _NewBillState extends State<NewBill> {
  //controllers for input text fields
  final shopNameController = TextEditingController();
  final itemNameController = TextEditingController();
  final itemCostController = TextEditingController();
  final itemWarrantyLengthController = TextEditingController();
  final purchaseDateController = TextEditingController();
  final warrantyUntilController = TextEditingController();
  String itemCategory;
  DateTime _selectedDate = DateTime
      .now(); //initializing with 'now' to have possibility to add warranty length from the beginning
  DateTime _warrantyValidUntil;

  //function which is triggered by button and input fields
  void submitData() {
    final enteredShopName = shopNameController.text;
    final enteredItemName = itemNameController.text;
    final enteredCost = double.parse(itemCostController.text);
    final enteredCategory = itemCategory;
    final calculatedWarranty = _warrantyValidUntil;
    //final id = DateTime.now();

    //pointer, we're referring to function
    //we're "returning" parameters in the brackets
    widget.addNewBill(enteredShopName, enteredItemName, enteredCost,
        enteredCategory, calculatedWarranty);

    //closing the popped up screen
    Navigator.of(context).pop();
  }

  //function which shows the date picker menu and sets pickedDate to selectedDate
  void _presentDatePicker() {
    //Gives future, because we're waiting for user to pick up the date
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  void warrantyValidUntil() {
    if (itemWarrantyLengthController.text == '') {
      setState(() {
        _warrantyValidUntil = null;
      });
    } else {
      setState(() {
        _warrantyValidUntil = DateTime(
            _selectedDate.year,
            _selectedDate.month + int.parse(itemWarrantyLengthController.text),
            _selectedDate.day);
      });
    }

    setState(() {
      _warrantyValidUntil = DateTime(
          _selectedDate.year,
          _selectedDate.month + int.parse(itemWarrantyLengthController.text),
          _selectedDate.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Data input - SHOP
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 35, 25, 0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter name of a shop',
                  labelText: 'Shop',
                ),
                controller: shopNameController,
                onSubmitted: (_) => submitData(),
              ),
            ),
            //Data input - ITEM NAME
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 25,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter name of an item',
                  labelText: 'Name',
                ),
                controller: itemNameController,
                onSubmitted: (_) => submitData(),
              ),
            ),
            //Data input - ITEM COST
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 25,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter cost of an item',
                  labelText: 'Cost',
                ),
                controller: itemCostController,
                onSubmitted: (_) => submitData(),
              ),
            ),
            //Data input - ITEM WARRANTY LENGTH
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 25,
              ),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Enter warranty length in months',
                    labelText: 'Warranty length'),
                controller: itemWarrantyLengthController,
                onChanged: (_) => warrantyValidUntil(),
                onSubmitted: (_) => warrantyValidUntil(),
              ),
            ),
            //Data input - ITEM CATEGORY
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 25,
              ),
              child: ItemCategoryMenu(
                chosenCategory: (value) {
                  setState(() {
                    itemCategory = value;
                  });
                },
              ),
            ),
            //DateTime - CHOOSE START DAY
            Container(
              height: 45,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 10,
                    ),
                    child: FlatButton(
                      textColor: Theme.of(context).accentColor,
                      child: Text(
                        'Choose warranty start date:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? ''
                          : '${DateFormat.yMMMd().format(_selectedDate)}',
                    ),
                  ),
                ],
              ),
            ),
            //DateTime - WARRANTY VALID UNTIL
            Container(
              height: 25,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 25,
                    ),
                    child: Text(
                      'Warranty valid until:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _warrantyValidUntil == null
                          ? ''
                          : '${DateFormat.yMMMd().format(_warrantyValidUntil)}',
                    ),
                  ),
                ],
              ),
            ),
            //TO - DO Make add Graphic
            Container(
              child: PhotoPreview(),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 25,
              ),
              child: RaisedButton(
                child: Text('Add bill'),
                onPressed: submitData,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
