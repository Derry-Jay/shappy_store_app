import 'package:shappy_store_app/src/models/address.dart';

class Store {
  String imageURL;
  final int storeID;
  final Address storeAddress;
  final String storeCat, storeName, ownerName, shopMob;
  Store(this.storeID, this.storeCat, this.storeName, this.ownerName,
      this.shopMob, this.storeAddress, this.imageURL);
  factory Store.fromMap(Map<String, dynamic> json) {
    return Store(
        json['shop_ID'],
        json['shop_categories'],
        json['shop_name'],
        json['owner_name'],
        json['shop_Mobile'],
        Address.fromJSON(json),
        json['shop_IMG']);
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["shop_ID"] = storeID.toString();
    map["shop_Mobile"] = shopMob;
    map["owner_name"] = ownerName;
    map["shop_name"] = storeName;
    map["shop_IMG"] = imageURL;
    map["address"] = storeAddress.address != null && storeAddress.address != ""
        ? storeAddress.address
        : (storeAddress.getAddress(storeAddress));
    return map;
  }

  Map<String, dynamic> toProfileMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["shop_ID"] = storeID.toString();
    map["shop_name"] = storeName;
    map["owner_name"] = ownerName;
    map["shop_Mobile"] = shopMob;
    map["shop_IMG"] = imageURL;
    return map;
  }

  bool operator ==(other) => (other is Store && other.storeID == storeID);

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}
