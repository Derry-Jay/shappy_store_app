class Order {
  int orderStatus;
  String cancelBy;
  final int orderID, paymentType, userID;
  final String userName,
      date,
      area,
      total,
      orderTime,
      phNo,
      lat,
      lng,
      cancelReason;
  Order(
      this.orderID,
      this.userID,
      this.userName,
      this.phNo,
      this.lat,
      this.lng,
      this.area,
      this.orderStatus,
      this.date,
      this.orderTime,
      this.paymentType,
      this.total,
      this.cancelReason,
      this.cancelBy);
  factory Order.fromJSON(Map<String, dynamic> json) {
    return Order(
        json['order_ID'],
        json['user_ID'],
        json['username'],
        json['phone_No'],
        json['cus_lat'].toString(),
        json['cus_lon'].toString(),
        json['area'],
        json['order_status'],
        json['order_date'].toString(),
        json['order_time'],
        json['payment_type'],
        json['Total'].toString(),
        json['cancel_reason'],
        json['cancel_by']);
  }

  @override
  bool operator ==(other) =>
      other is Order && other.orderID == orderID && other.userID == userID;

  @override
  // TODO: implement hashCode
  int get hashCode => orderID.hashCode;

  bool isIn(List<Order> list) {
    for (Order e in list) {
      if (e == this) return true;
    }
    return false;
  }
}
