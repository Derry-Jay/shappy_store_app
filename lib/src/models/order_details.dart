import 'package:shappy_store_app/src/models/ordered_product.dart';

import 'order.dart';

class OrderDetails {
  final bool success, status;
  final String message;
  final Order customer;
  final List<OrderedProduct> products;
  OrderDetails(
      this.success, this.status, this.message, this.customer, this.products);
  factory OrderDetails.fromMap(Map<String, dynamic> json) {
    return OrderDetails(
        json['success'],
        json['status'],
        json['message'],
        Order.fromJSON(json['userDetails']),
        json['orderproducts'] != null
            ? List.from(json['orderproducts'])
                .map((element) => OrderedProduct.fromMap(element))
                .toList()
            : <OrderedProduct>[]);
  }
}
