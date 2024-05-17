import 'package:shappy_store_app/src/models/store_setting.dart';

class StoreSettingBase{
  final bool success;
  final String message;
  final StoreSetting settings;
  StoreSettingBase(this.success,this.message,this.settings);
  factory StoreSettingBase.fromMap(Map<String, dynamic> json){
    return StoreSettingBase(json['success'], json['message'], StoreSetting.fromMap(json['result']));
  }
}