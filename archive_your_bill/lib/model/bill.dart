import 'package:cloud_firestore/cloud_firestore.dart';

class Bill{
  String id;
  String name;
  String category;
  String image;
  List subIngredients;
  Timestamp createdAt;


  //named constructor
  //we're passing a Map
  //dynamic because they will be different things
  Bill.fromMap(Map<String, dynamic> data){
    id = data['id'];
    name = data['name'];
    category = data['category'];
    image = data['image'];
    subIngredients = data['subIngredients'];
    createdAt = data['createdAt'];
  }

}