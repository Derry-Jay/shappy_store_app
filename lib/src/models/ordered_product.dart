class OrderedProduct{
  final int cartCount;
  final double price;
  final String productName;
  OrderedProduct(this.productName,this.cartCount,this.price);
  factory OrderedProduct.fromMap(Map<String, dynamic> json) {
    return OrderedProduct(
      json['product_name'],
      json['cartquantity'],
      json['price'].toDouble()
    );
  }
}