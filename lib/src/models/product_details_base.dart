import 'product.dart';
class ProductDetailsBase{
  final bool success;
  final bool status;
  final String message;
  final Product product;
  ProductDetailsBase(this.success,this.status,this.message,this.product);
  factory ProductDetailsBase.fromMap(Map<String, dynamic> json){
    return ProductDetailsBase(json['success'], json['status'], json['message'], json['result'] != null ? Product.fromMap(json['result']) : null);
  }
}