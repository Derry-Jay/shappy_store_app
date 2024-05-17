import 'product.dart';

class ProductBase {
  final bool success;
  final bool status;
  final String message;
  final List<Product> products;
  ProductBase(this.success, this.status, this.message, this.products);
  factory ProductBase.fromMap(Map<String, dynamic> json) {
    return ProductBase(
        json['success'],
        json['status'],
        json['message'],
        json['result'] != null && json['result'] != []
            ? List.from(json['result'])
                .map((element) => Product.fromMap(element))
                .toList()
            : []);
  }
}
