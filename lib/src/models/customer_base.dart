import 'customer.dart';

class CustomerBase {
  final bool success;
  final bool status;
  final String message;
  final List<Customer> customers;
  CustomerBase(this.success, this.status, this.message, this.customers);
  factory CustomerBase.fromMap(Map<String, dynamic> json) {
    return CustomerBase(
        json['success'],
        json['status'],
        json['message'],
        json['result'] != null && json['result'] != []
            ? List.from(json['result'])
                .map((element) => Customer.fromMap(element))
                .toList()
            : []);
  }
}
