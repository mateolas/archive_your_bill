import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  String id;
  String nameShop;
  String nameItem;
  String category;
  String image;
  
  Timestamp createdAt;
  Timestamp updatedAt;

  Bill();

  Bill.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    nameShop = data['name'];
    category = data['category'];
    image = data['image'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nameShop,
      'category': category,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}