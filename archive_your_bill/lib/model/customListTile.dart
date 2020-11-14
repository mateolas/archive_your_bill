import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  categoryToIconWhite(String category) {
    switch (category) {
      case "Electronics":
        {
          return Icon(
            Icons.computer,
            size: 30,
            color: Colors.white,
          );
        }
        break;

      case "Fashion":
        {
          return Icon(Icons.local_offer, size: 30, color: Colors.white);
        }
        break;

      case "Sports":
        {
          return Icon(Icons.fitness_center, size: 32, color: Colors.white);
        }
        break;

      case "Books/Music/Culture":
        {
          return Icon(Icons.format_quote, size: 30, color: Colors.white);
        }
        break;

      case "Home":
        {
          return Icon(Icons.home, size: 30, color: Colors.white);
        }
        break;

      case "Food":
        {
          return Icon(Icons.local_dining, size: 30, color: Colors.white);
        }
        break;

      case "Health":
        {
          return Icon(Icons.local_hospital, size: 30, color: Colors.white);
        }
        break;

      case "Services":
        {
          return Icon(Icons.build, size: 30, color: Colors.white);
        }
        break;

      case "Other":
        {
          return Icon(Icons.receipt, size: 30, color: Colors.white);
        }
        break;

      case "All":
        {
          return Text("ALL",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ));
        }
        break;
    }
  }

  var titleName;

  CustomListTile(this.titleName);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
      child: Text(
        this.titleName,
        style: TextStyle(
            fontSize: 20, color: Colors.green, fontWeight: FontWeight.w600),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      width: 150,
    ));
  }
}
