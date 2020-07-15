//class defines the data structure of single bill

class Bill {
  String id;
  String shopName;
  String itemName;
  double itemCost;
  String itemType;
  int itemWarrantyLengthMonths; 
  DateTime purchaseDate;
  DateTime warrantyUntil;

  Bill({this.id,this.shopName,this.itemName,this.itemType,this.itemCost, this.itemWarrantyLengthMonths, this.purchaseDate, this.warrantyUntil});

  

}