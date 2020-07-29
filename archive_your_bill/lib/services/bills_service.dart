import 'package:archive_your_bill/models/bill.dart';


//class / service to get data from API through http request
//logic for fetching data from data source (API / database / whatever ;)
//we're returning a data and another widget doesn't know / cares doest it comes from
//API / database /hardcoded or whatever ;P
class BillsService {
  List<Bill> getBillsList() {
    return [
      Bill(
        billID: '1',
        shopName: 'Note 1',
        purchaseDate: DateTime.now(),
        latestEditDateTime: DateTime.now(),
      ),
      Bill(
        billID: '2',
        shopName: 'Note 2',
        purchaseDate: DateTime.now(),
        latestEditDateTime: DateTime.now(),
      ),
      Bill(
        billID: '3',
        shopName: 'Note 3',
        purchaseDate: DateTime.now(),
        latestEditDateTime: DateTime.now(),
      ),
    ];
  }
}
