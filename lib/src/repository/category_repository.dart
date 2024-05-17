import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shappy_store_app/src/models/product_category.dart';
import 'package:shappy_store_app/src/models/product_category_base.dart';

Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();

Future<List<ProductCategory>> getProductCategories(String shopID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}productCategoryList';
  try {
    final response = await client.post(url, body: {
      "shop_ID": shopID
    }, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return ProductCategoryBase.fromMap(jsonString).categories;
    } else {
      throw Exception('Unable to fetch categories from the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<int> addProductCategory(String shopID, String proCat) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}productCategoryAdd';
  try {
    final response = await client.post(url, body: {
      "shop_ID": shopID,
      "product_category": proCat
    }, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonString["productCat_ID"];
    } else {
      throw Exception('Unable to update product data to the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<Map<String, dynamic>> updateProductCategory(
    String shopID, String proCat, String proCatID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}productCategoryEdit';
  try {
    final response = await client.put(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID,
      "product_category": proCat,
      "productCat_ID": proCatID
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonString;
    } else {
      throw Exception('Unable to update product status to the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<List<ProductCategory>> getSearchedCategories(String pattern) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}ShopProductCatSearch';
  try {
    final response = await client.post(url, body: {
      "shop_ID": sharedPrefs.getString("spShopID"),
      "keyword" : pattern,
      "paging" : "0"
    }, headers: {
      HttpHeaders.authorizationHeader:
      "Bearer " + sharedPrefs.getString("apiToken")
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
      json.decode(response.body) as Map<String, dynamic>;
      return ProductCategoryBase.fromMap(jsonString).categories;
    } else {
      throw Exception('Unable to fetch categories from the REST API');
    }
  } catch (e) {
    throw e;
  }
}
