import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/models/product.dart';
import 'package:shappy_store_app/src/models/product_category.dart';
import 'package:shappy_store_app/src/models/uom.dart';
import 'package:shappy_store_app/src/repository/category_repository.dart'
    as crepos;
import 'package:shappy_store_app/src/repository/product_repository.dart'
    as prepos;
import 'package:toast/toast.dart';

class CategoryAndProductController extends ControllerMVC {
  List<MeasurementUnit> units;
  List<ProductCategory> categories, searchedCategories;
  List<Product> products, categorizedProducts, searchedProducts;
  int proCatID, proID;
  String imageUrl;
  GlobalKey<ScaffoldState> scaffoldKey;
  CategoryAndProductController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void waitForProductCategories({String shopID}) async {
    await crepos.getProductCategories(shopID).then((value) {
      if (value != null) {
        setState(() => categories = value);
        if (categories.length == 0)
          Toast.show("No Categories", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else
        Toast.show("No Categories", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void waitForProducts({String shopID}) async {
    await prepos.fetchProducts(shopID).then((value) {
      if (value != null) {
        setState(() => products = value);
        if (products.length == 0)
          Toast.show("No Products", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else
        Toast.show("No Products", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e.toString(), context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  Future<void> waitForUnits(String str) async {
    final stream = await prepos.getUnit(str);
    if (stream != null) setState(() => units = stream);
  }

  void waitUntilAddCategory({String shopID, String proCat}) async {
    await crepos.addProductCategory(shopID, proCat).then((value) {
      if (value != null && value != 0) {
        setState(() => proCatID = value);
        // Toast.show(value.toString(), context,
        //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else
        Toast.show("Category Add Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void waitUntilEditCategory(
      {String shopID, String proCat, String proCatID}) async {
    await crepos.updateProductCategory(shopID, proCat, proCatID).then((value) {
      if (value != null && value["success"] && value["status"]) {
        Toast.show(value["message"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else
        Toast.show("Category Edit Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void waitUntilAddProduct({Map<String, dynamic> body}) async {
    await prepos.addProductDetails(body).then((value) {
      if (value != null && value != 0) {
        setState(() => proID = value);
        // Toast.show(value.toString(), context,
        //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else
        Toast.show("Product Add Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void waitUntilEditProduct({Map<String, dynamic> body}) async {
    await prepos.updateProductDetails(body).then((value) {
      if (value != null && value["success"] && value["status"]) {
        print(value["message"]);
        Toast.show(value["message"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pop(context);
      } else
        Toast.show("Product Edit Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void waitUntilProductImageUpload(PickedFile image) async {
    await prepos.uploadProductImage(image).then((value) {
      if (value != null && value.success && value.status)
        setState(() => imageUrl = value.imageUrl);
      print(value.message);
      Toast.show(value.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void setStatus(int index) async {
    dynamic pro = {
      "product_status": (products[index].productStatus == 1
              ? products[index].productStatus - 1
              : products[index].productStatus + 1)
          .toString(),
      "product_ID": products[index].proID.toString()
    };
    await prepos.updateProductStatus(pro).then((value) {
      if (value != null &&
          value.isNotEmpty &&
          value["status"] &&
          value["success"]) {
        if (value["message"].endsWith("unlive ")) {
          setState(() => products[index].productStatus = 0);
          Toast.show(
              products[index].name + " Made Unlive Successfully", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else if (value["message"].endsWith("live ")) {
          setState(() => products[index].productStatus = 1);
          Toast.show(products[index].name + " Made Live Successfully", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }
    });
  }

  void listenForCategoryBasedProducts(String productCat_ID) async {
    final stream = await prepos.getProductsBasedOnCategories(productCat_ID);
    if (stream != null)
      setState(() => categorizedProducts = stream);
    else
      setState(() => categorizedProducts = <Product>[]);
  }

  void waitForSearchedCategories(String pattern) async {
    if (pattern == null || pattern == "") {
      setState(() => searchedCategories = <ProductCategory>[]);
      Toast.show("No Product Categories Found", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      final stream = await crepos.getSearchedCategories(pattern);
      if (stream != null && stream.isNotEmpty)
        setState(() => searchedCategories = stream);
      else {
        setState(() => searchedCategories = <ProductCategory>[]);
        Toast.show("No Product Categories Found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }
  }

  void waitForSearchedProducts(String pattern) async {
    if (pattern == null || pattern == "") {
      setState(() => searchedProducts = <Product>[]);
      Toast.show("No Products Found", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      final stream = await prepos.getSearchedProducts(pattern);
      if (stream != null && stream.isNotEmpty)
        setState(() => searchedProducts = stream);
      else {
        setState(() => searchedProducts = <Product>[]);
        Toast.show("No Products Found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }
  }
}
