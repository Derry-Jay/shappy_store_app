class OTPSuccess {
  final bool success, status, registered;
  final String token, message;
  final int shopID, approvedStatus;
  OTPSuccess(this.success, this.status, this.registered, this.message,
      this.token, this.shopID, this.approvedStatus);
  factory OTPSuccess.fromMap(Map<String, dynamic> json) {
    return OTPSuccess(
        json['success'],
        json['status'],
        json['registerd'],
        json['Message'],
        json['jwt_token'],
        json['shop_ID'],
        json['shop_Approval']);
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map['success'] = success;
    map['status'] = status;
    map['Message'] = message;
    map['registerd'] = registered;
    map['jwt_token'] = token;
    map['shop_ID'] = shopID;
    map['shop_Approval'] = approvedStatus;
    return map;
  }
}
