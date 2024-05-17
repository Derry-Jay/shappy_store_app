import 'package:shappy_store_app/src/models/store.dart';

class StoreBase{
  final bool success;
  final String message;
  final Store store;
  StoreBase(this.success,this.message,this.store);
  factory StoreBase.fromMap(Map<String, dynamic> json){
    return StoreBase(json['success'], json['message'], Store.fromMap(json['result']));
  }
}