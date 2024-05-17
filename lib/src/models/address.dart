import '../helpers/custom_trace.dart';

class Address {
  int id, plotNo;
  String address, landMark, area;
  double latitude, longitude;
  bool isDefault;

  Address();

  Address.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['address_ID'] != null ? jsonMap['address_ID'] : 0;
      plotNo = jsonMap['shop_No'] != null ? jsonMap['shop_No'] : 0;
      area = jsonMap['area'] != null ? jsonMap['area'] : "";
      address = jsonMap['address'] != null ? jsonMap['address'] : "";
      landMark = jsonMap['landmark'] != null ? jsonMap['landmark'] : "";
      latitude =
          jsonMap['lat'] != null ? jsonMap['lat'].toDouble() : null;
      longitude =
          jsonMap['lon'] != null ? jsonMap['lon'].toDouble() : null;
      isDefault = jsonMap['is_default'] ?? false;
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }

  bool operator ==(other) => (other is Address && other.id == id);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["area"] = area;
    map["shop_No"] = plotNo;
    map["latitude"] = latitude;
    map["landmark"] = landMark;
    map["longitude"] = longitude;
    map["is_default"] = isDefault;
    map["address"] = address != null && address != ""
        ? address
        : getAddress(Address.fromJSON(map));
    return map;
  }

  String getAddress(Address address) {
    if (address == null)
      return "";
    else if (address.address != null && address.address != "")
      return address.address;
    else {
      String oprs = address.plotNo != null && address.plotNo.toString() != ""
          ? address.plotNo.toString() + ", "
          : "";
      oprs +=
          address.area != null && address.area != "" ? address.area + ". " : "";
      return oprs;
    }
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}
