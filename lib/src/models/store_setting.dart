class StoreSetting {
  final int shopID, shopStatus, codStatus, storePickupStatus, deliverRadius;
  final String lat, long;
  StoreSetting(this.shopID, this.shopStatus, this.codStatus,
      this.storePickupStatus, this.deliverRadius, this.lat, this.long);
  factory StoreSetting.fromMap(Map<String, dynamic> json) {
    return StoreSetting(
        json['shop_ID'],
        json['shop_status'],
        json['COD_status'],
        json['store_pickupStatus'],
        json['delivery_radius'],
        json['lat'].toString(),
        json['lon'].toString());
  }
  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = new Map<String,dynamic>();
    map["shop_ID"]=shopID;
    map['shop_status']=shopStatus;
    map['COD_status']=codStatus;
    map['store_pickupStatus']=storePickupStatus;
    map['delivery_radius']=deliverRadius;
    map['lat']=lat;
    map['lon']=long;
    // print(map);
    return map;
  }
}
