class Home {
  final int ordersPending,
      ordersCompleted,
      ordersCancelled,
      ordersPendingForApproval;
  final String shopName, revenue;
  Home(this.shopName, this.ordersPending, this.ordersCancelled,
      this.ordersCompleted, this.ordersPendingForApproval, this.revenue);
  factory Home.fromMap(Map<String, dynamic> json) {
    return Home(
        json['shop_name'],
        json['order_pending'],
        json['order_cancelled'],
        json['order_completed'],
        json['orders_waiting_for_approval'],
        json['revenue'].toString());
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map['shop_name'] = shopName;
    map['revenue'] = revenue;
    map['order_pending'] = ordersPending;
    map['order_cancelled'] = ordersCancelled;
    map['order_completed'] = ordersCompleted;
    map['Order_PendingForApproval'] = ordersPendingForApproval;
    return map;
  }
}
