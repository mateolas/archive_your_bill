import 'package:flutter/material.dart';

class ItemCategoryMenu extends StatefulWidget {
  final Function chosenCategory;
  
  ItemCategoryMenu({this.chosenCategory});
  
  @override
  _ItemCategoryMenuState createState() => _ItemCategoryMenuState();
}

class _ItemCategoryMenuState extends State<ItemCategoryMenu> {
  String dropdownValue = null;

   @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      //style: TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.chosenCategory(dropdownValue);
        });
      },
      items: <String>['Electronics', 'Clothes', 'Services', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text('Choose category'),
    );
  }
}
