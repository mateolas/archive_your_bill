//class defines the data structure of single bill

class Bill {
  String billID;
  String shopName;
  DateTime purchaseDate;
  DateTime latestEditDateTime;
  //String itemName;
  //double itemCost;
  //String itemCategory;
  //int itemWarrantyLengthMonths;

  Bill({
    this.billID,
    this.shopName,
    this.purchaseDate,
    this.latestEditDateTime,
  });
}
