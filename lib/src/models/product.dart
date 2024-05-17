import 'package:shappy_store_app/src/models/uom.dart';

class Product {
  final String name, description, image, proCat, price;
  final int weight, proID, shopID;
  int productStatus;
  MeasurementUnit unit;
  Product(this.shopID, this.proID, this.name, this.description, this.proCat,
      this.price, this.image, this.productStatus, this.weight, this.unit);
  factory Product.fromMap(Map<String, dynamic> json) => Product(
      json['shop_ID'],
      json['product_ID'],
      json['product_name'],
      json['product_description'],
      json['product_category'],
      json['price'].toString(),
      json['product_IMG'],
      json['product_status'],
      json['weight'],
      MeasurementUnit.fromMap(json));
  Map toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["price"] = price;
    map["shop_ID"] = shopID;
    map["product_ID"] = proID;
    map["product_name"] = name;
    map["Product_IMG"] = image;
    map["product_description"] = description;
    return map;
  }

  bool operator ==(other) =>
      (other is Product && other.proID == proID && other.shopID == shopID);

  @override
  // TODO: implement hashCode
  int get hashCode => proID.hashCode;
}
