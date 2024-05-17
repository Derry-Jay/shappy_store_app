class Customer {
  final int userID, orderCount;
  final String userName, area, phNo, aov, tov;
  Customer(this.userID, this.userName, this.phNo, this.area, this.orderCount,
      this.tov, this.aov);
  factory Customer.fromMap(Map<String, dynamic> json) => Customer(
      json['user_ID'],
      json['username'],
      json['phone_no'],
      json['area'],
      json['order_Count'] ?? json['orderCount'],
      json['TOV'].toString(),
      json['AOV'].toString());
  @override
  bool operator ==(other) => other is Customer && userID == other.userID;

  @override
  // TODO: implement hashCode
  int get hashCode => userID.hashCode;

  bool isIn(List<Customer> customers) {
    for (Customer e in customers) if (e == this) return true;
    return false;
  }
}
