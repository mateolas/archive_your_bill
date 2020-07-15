import "package:flutter/material.dart";

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

  void submitData() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        //Data input - shop name
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 45, 25, 2),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter name of a shop',
              labelText: 'Shop',
            ),
            controller: shopNameController,
            onSubmitted: (_) {},
          ),
        ),
        //Data input - item name
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 25,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter name of an item',
              labelText: 'Name',
            ),
            controller: itemNameController,
            onSubmitted: (_) {},
          ),
        ),
        //Data input - item cost
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 25,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter cost of an item',
              labelText: 'Item',
            ),
            controller: itemCostController,
            onSubmitted: (_) {},
          ),
        ),
        //Data input - item type
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 25,
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter type of an item',
              labelText: 'Type',
            ),
            controller: itemCostController,
            onSubmitted: (_) {},
          ),
        ),
      ],
    );
  }
}
