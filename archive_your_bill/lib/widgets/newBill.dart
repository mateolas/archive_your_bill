import "package:flutter/material.dart";

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
  final itemTypeController = TextEditingController();
  final itemCostController = TextEditingController();
  final itemWarrantyLengthMonths = TextEditingController();
  final purchaseDateController = TextEditingController();
  final warrantyUntilController = TextEditingController();


  //function which is triggered by button and input fields
  void submitData() {
    final enteredShopName = shopNameController.text;
    final enteredItemName = itemNameController.text;
    final enteredCost = double.parse(itemCostController.text);

    //function definition / pointer, we're referring to function
    //we're "returning" parameters in the brackets
    widget.addNewBill(enteredShopName,enteredItemName,enteredCost);

    //closing the popped up screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        //Data input - shop name
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 45, 25, 0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter name of a shop',
              labelText: 'Shop',
            ),
            controller: shopNameController,
            onSubmitted: (_) => submitData(),
          ),
        ),
        //Data input - item name
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
        //Data input - item cost
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
        //Data input - item type
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 25,
          ),
          child: Text('Item type'),
        ),
        //Data input - item warranty length
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 25,
          ),
          child: Text('Purchase date'),
        ),
        //Data input - purchase date
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 25,
          ),
          child: Text('Purchase date'),
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
    );
  }
}
