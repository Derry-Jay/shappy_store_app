import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shappy_store_app/src/models/shop_category.dart';
import 'package:shappy_store_app/src/models/shop_category_base.dart';
import 'package:shappy_store_app/src/models/store.dart';
import 'package:shappy_store_app/src/models/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/models/store_base.dart';
import 'package:shappy_store_app/src/models/image_upload.dart';
import 'package:shappy_store_app/src/models/customer_base.dart';
import 'package:global_configuration/global_configuration.dart';

Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
Future<Store> getShopData(String shopID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}storeProfile';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return StoreBase.fromMap(jsonString).store;
    } else {
      throw Exception('Unable to fetch customers from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<Map<String, dynamic>> updateShopData(Map<String, dynamic> body) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}storeProfileEdit';
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
      throw Exception('Unable to fetch customers from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<List<Customer>> getShopCustomers(String shopID, String page) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}myCustomerList';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID,
      "pages": page
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return CustomerBase.fromMap(jsonString).customers;
    } else {
      throw Exception('Unable to fetch customers from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<ImageUpload> uploadShopImage(PickedFile image) async {
  try {
    var uri =
        Uri.parse('${GlobalConfiguration().getString('base_url')}imageUpload');
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

Future<List<StoreCategory>> getShopCategories() async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}getCategoriesList';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer " +
          (sharedPrefs.containsKey("apiToken")
              ? sharedPrefs.getString("apiToken")
              : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjkwNCIsImlhdCI6MTYwMzI3NTUwNX0.jW-E6RqPqh_t5UJCw5uKE4Gav_iEIKDfQ5lLdDI7oSE")
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return StoreCategoryBase.fromMap(jsonString).shopCategories;
    } else {
      throw Exception('Unable to fetch shop categories from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<Map<String, dynamic>> updateNewShopData(
    Map<String, dynamic> body) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}shopRegister';
  try {
    final response = await client.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer " +
              (sharedPrefs.containsKey("apiToken")
                  ? sharedPrefs.getString("apiToken")
                  : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6IjkwNCIsImlhdCI6MTYwMzI3NTUwNX0.jW-E6RqPqh_t5UJCw5uKE4Gav_iEIKDfQ5lLdDI7oSE")
        },
        body: body);
    print(response.body);
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonString;
    } else {
      throw Exception('Unable to fetch customers from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}
