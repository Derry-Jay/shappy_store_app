import 'order.dart';

class SearchedProductBase {
  bool success, status;
  List<Order> orders = <Order>[];
  SearchedProductBase();
  SearchedProductBase.fromMap(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    orders = json['result'] != null && json['result'].isNotEmpty
        ? List.from(json['result'])
            .map((element) => Order.fromJSON(element))
            .toList()
        : <Order>[];
  }
}
