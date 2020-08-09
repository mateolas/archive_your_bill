import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  String id;
  String name;
  String category;
  String image;
  List subIngredients;
  Timestamp createdAt;
  Timestamp updatedAt;

  Bill();

  //named constructor
  //we're passing a Map
  //dynamic because they will be different things
  Bill.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    category = data['category'];
    image = data['image'];
    subIngredients = data['subIngredients'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

//function to upload bill to server
//need to return Map of type String
//to Map function will be used in our API file to upload bills
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'image': image,
      'subIngredients': subIngredients,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
