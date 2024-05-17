import 'package:shappy_store_app/src/models/product_category.dart';

class ProductCategoryBase {
  final bool success, status;
  final List<ProductCategory> categories;
  ProductCategoryBase(this.success, this.status, this.categories);
  factory ProductCategoryBase.fromMap(Map<String, dynamic> json) {
    return ProductCategoryBase(
        json['success'],
        json['status'],
        json['result'] != null && json['result'] != []
            ? List.from(json['result'])
                .map((element) => ProductCategory.fromMap(element))
                .toList()
            : []);
  }
}
