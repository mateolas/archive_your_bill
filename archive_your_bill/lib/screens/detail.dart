import 'package:archive_your_bill/api/food_api.dart';
import 'package:archive_your_bill/screens/bill_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archive_your_bill/model/food.dart';

import 'package:archive_your_bill/notifier/bill_notifier.dart';

class FoodDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    _onFoodDeleted(Food food) {
      Navigator.pop(context);
      foodNotifier.deleteFood(food);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(foodNotifier.currentFood.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  foodNotifier.currentFood.image != null
                      ? foodNotifier.currentFood.image
                      : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 24),
                Text(
                  foodNotifier.currentFood.name,
                  style: TextStyle(
                    fontSize: 40,
                  ),
                ),
                Text(
                  'Category: ${foodNotifier.currentFood.category}',
                  style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'button1',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) {
                  return FoodForm(
                    isUpdating: true,
                  );
                }),
              );
            },
            child: Icon(Icons.edit),
            foregroundColor: Colors.white,
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            heroTag: 'button2',
            onPressed: () =>
                deleteFood(foodNotifier.currentFood, _onFoodDeleted),
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
