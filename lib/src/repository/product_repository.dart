import 'dart:io';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shappy_store_app/src/models/image_upload.dart';
import 'package:shappy_store_app/src/models/product.dart';
import 'package:shappy_store_app/src/models/product_base.dart';
import 'package:shappy_store_app/src/models/product_details_base.dart';
import 'package:shappy_store_app/src/models/uom.dart';
import 'package:shappy_store_app/src/models/uom_base.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();

Future<List<Product>> fetchProducts(String shopID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}shopProductsList';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID,
      "pages": "0"
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return ProductBase.fromMap(jsonString).products;
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<Product> fetchProductDetails(String productID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}productDetails';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "product_ID": productID
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return ProductDetailsBase.fromMap(jsonString).product;
    } else {
      throw Exception('Unable to fetch product details from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<Map<String, dynamic>> updateProductDetails(
    Map<String, dynamic> body) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}productEdit';
  try {
    final response = await client.put(url,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + sharedPrefs.getString("apiToken")
        },
        body: body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonString;
    } else {
      throw Exception('Unable to upload product details to the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<int> addProductDetails(Map<String, dynamic> body) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url = '${GlobalConfiguration().getString('base_url')}productAdd';
  try {
    final response = await client.post(url,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + sharedPrefs.getString("apiToken")
        },
        body: body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonString["product_ID"];
    } else {
      throw Exception('Unable to add product details to the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<Map> updateProductStatus(dynamic pro) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}productStatusUpdate';
  try {
    final response = await client.put(url,
        headers: {
          HttpHeaders.authorizationHeader:
              "Bearer " + sharedPrefs.getString("apiToken")
        },
        body: pro);
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

Future<List<MeasurementUnit>> getUnit(String pat) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url = '${GlobalConfiguration().getString('base_url')}uoms';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return MeasurementUnitBase.fromMap(jsonString).units;
    } else {
      throw Exception("Unable to get Units from the REST API");
    }
  } catch (e) {
    throw e;
  }
}

Future<ImageUpload> uploadProductImage(PickedFile image) async {
  try {
    var uri =
        Uri.parse('${GlobalConfiguration().getString('base_url')}productImage');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath('lic', image.path,
          contentType: MediaType('application', 'jpg')));
    var response = await request.send();
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(await response.stream.bytesToString());
      return ImageUpload.fromMap(jsonString);
    }
  } catch (e) {
    print(e);
    throw (e);
  }
}

Future<List<Product>> getProductsBasedOnCategories(String productCat_ID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url = '${GlobalConfiguration().getString('base_url')}ProductCat';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "productCat_ID": productCat_ID,
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return ProductBase.fromMap(jsonString).products;
    } else {
      throw Exception('Unable to fetch product details from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<List<Product>> getSearchedProducts(String pattern) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url = '${GlobalConfiguration().getString('base_url')}ShopProductSearch';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": sharedPrefs.getString("spShopID"),
      "keyword": pattern,
      "paging": "0"
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return ProductBase.fromMap(jsonString).products;
    } else {
      throw Exception('Unable to fetch product details from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}
