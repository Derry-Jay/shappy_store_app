import 'package:shappy_store_app/src/models/ordered_product.dart';

class OrderedProductBase {
  final bool success, status;
  final List<OrderedProduct> orderedProducts;
  OrderedProductBase(this.success, this.status, this.orderedProducts);
  factory OrderedProductBase.fromMap(Map<String, dynamic> json) {
    return OrderedProductBase(
        json['success'],
        json['status'],
        json['result'] != null
            ? List.from(json['result'])
                .map((element) => OrderedProduct.fromMap(element))
                .toList()
            : <OrderedProduct>[]);
  }
}
