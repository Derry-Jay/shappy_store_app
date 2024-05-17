import 'order.dart';
import 'customer.dart';

class CustomerDetails {
  final bool success, status;
  final Customer customer;
  final List<Order> orders;
  CustomerDetails(this.success, this.status, this.customer, this.orders);
  factory CustomerDetails.fromMap(Map<String, dynamic> json) {
    return CustomerDetails(
        json['success'],
        json['status'],
        Customer.fromMap(json['userDetails']),
        json['orderDetails'] != null && json['orderDetails'] != []
            ? List.from(json['orderDetails'])
                .map((element) => Order.fromJSON(element))
                .toList()
            : []);
  }
}
