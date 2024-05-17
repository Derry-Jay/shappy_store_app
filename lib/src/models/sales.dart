import 'package:shappy_store_app/src/models/response.dart';

import 'order.dart';

class Sales {
  final Response response;
  final int pendingOrdersCount, completedOrdersCount, cancelledOrdersCount;
  final String revenue;
  final List<Order> orders;
  Sales(this.response, this.pendingOrdersCount, this.completedOrdersCount,
      this.cancelledOrdersCount, this.orders, this.revenue);

  factory Sales.fromMap(Map<String, dynamic> json) {
    return Sales(
        Response.fromMap(json),
        json["order_pending"],
        json["order_completed"],
        json["order_cancelled"],
        json['orders'] != null && json['orders'] != []
            ? List.from(json['orders'])
                .map((element) => Order.fromJSON(element))
                .toList()
            : [],
        json["revenue"].toString());
  }
}
