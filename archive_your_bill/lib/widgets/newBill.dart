import "package:flutter/material.dart";

class NewBill extends StatefulWidget {
  Function addNewBill;

  NewBill(this.addNewBill);

  @override
  _NewBillState createState() => _NewBillState();
}

class _NewBillState extends State<NewBill> {
  //controllers for input text fields
  final idController = TextEditingController();
  final shopNameController = TextEditingController();
  final itemName = TextEditingController();
  final itemType = TextEditingController();
  final itemCost = TextEditingController();
  final itemWarrantyLengthMonths = TextEditingController();
  final purchaseDateController = TextEditingController();
  final warrantyUntilController = TextEditingController();

  void submitData() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter name of a shop',
              labelText: 'Shop',
            ),
            controller: shopNameController,
            onSubmitted: (_) {},
          ),
        ),
        Container(
          child: Text('Test2'),
        ),
      ],
    );
  }
}
