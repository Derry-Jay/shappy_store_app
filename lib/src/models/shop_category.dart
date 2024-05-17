class StoreCategory {
  final int shopCatID;
  final String shopCatName, imageLink, shopCatColour;
  StoreCategory(
      this.shopCatID, this.shopCatName, this.shopCatColour, this.imageLink);
  factory StoreCategory.fromMap(Map<String, dynamic> json) => (json == null
      ? null
      : StoreCategory(json['cat_ID'], json['shop_categories'],
          json['cat_fgClr'], json['category_IMG']));
  bool operator ==(other) =>
      (other is StoreCategory && other.shopCatID == shopCatID);

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
