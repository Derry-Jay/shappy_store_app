import 'package:shappy_store_app/src/models/shop_category.dart';

class StoreCategoryBase {
  final bool success, status;
  final List<StoreCategory> shopCategories;
  StoreCategoryBase(this.success, this.status, this.shopCategories);
  factory StoreCategoryBase.fromMap(Map<String, dynamic> json) {
    return StoreCategoryBase(
        json['success'],
        json['status'],
        json['result'] != null && json['result'] != []
            ? List.from(json['result'])
                .map((element) => StoreCategory.fromMap(element))
                .toList()
            : []);
  }
}
