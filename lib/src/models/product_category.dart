class ProductCategory {
  final int shopID, proCatID;
  final String proCat;

  ProductCategory(this.proCatID, this.proCat, this.shopID);

  factory ProductCategory.fromMap(Map<String, dynamic> json) => (json != null
      ? ProductCategory(
          json['productCat_ID'], json['product_category'], json['shop_ID'])
      : null);

  // static List<Category> fromJsonList(List list) {
  //   if (list == null) return null;
  //   return list.map((item) => Category.fromJson(item)).toList();
  // }

  ///custom comparing function to check if two users are equal
  bool operator ==(model) =>
      (model is ProductCategory && model.proCatID == proCatID);

  @override
  // TODO: implement hashCode
  int get hashCode => proCatID.hashCode;
}
