import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shappy_store_app/src/models/SearchProductsBase.dart';
import 'package:shappy_store_app/src/models/home.dart';
import 'package:shappy_store_app/src/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/models/order_base.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shappy_store_app/src/models/order_details.dart';

Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();

Future<List<Order>> getLiveOrders(String shopId,String page) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url = '${GlobalConfiguration().getString('base_url')}ordersList';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopId,
      "pages":page
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return OrderBase.fromMap(jsonString).order;
    } else {
      throw Exception('Unable to fetch orders from the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<List<Order>> getCancelOrders(String shopId,String page) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}ordersCancelledList';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopId,
      "pages":page
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return OrderBase.fromMap(jsonString).order;
    } else {
      throw Exception('Unable to fetch orders from the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<List<Order>> getDeliveredOrders(String shopId,String page) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}orderDeliveredDetails';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopId,
      "pages":page
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return OrderBase.fromMap(jsonString).order;
    } else {
      throw Exception('Unable to fetch orders from the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<OrderDetails> fetchOrderDetails(String orderID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}orderproductsList';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "order_ID": orderID
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return OrderDetails.fromMap(jsonString);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  } catch (e) {
    throw e;
  }
}

Future<Map> putCancelReason(String cancelReason, int orderID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}orderStoreCancel';
  try {
    final response = await client.put(url, body: {
      "order_status": "6",
      "order_ID": orderID.toString(),
      "cancel_reason": cancelReason
    }, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonString;
    } else {
      throw Exception('Unable to Cancel Order');
    }
  } catch (e) {
    throw e;
  }
}

Future<Map> approveOrder(int orderID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}orderAccept';
  try {
    final response = await client.put(url, body: {
      "order_status": "1",
      "order_ID": orderID.toString()
    }, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return jsonString;
    } else {
      throw Exception('Unable to Approve Order');
    }
  } catch (e) {
    throw e;
  }
}

Future<Map> deliverOrder(int orderID) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}orderDelivery';
  try {
    final response = await client.put(url, body: {
      "order_status": "5",
      "order_ID": orderID.toString()
    }, headers: {
      HttpHeaders.authorizationHeader:
      "Bearer " + sharedPrefs.getString("apiToken")
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
      json.decode(response.body) as Map<String, dynamic>;
      return jsonString;
    } else {
      throw Exception('Unable to Deliver Order');
    }
  } catch (e) {
    throw e;
  }
}

Future<Home> getHomePageData({String shopID, String nowDate}) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}home';
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
      return Home.fromMap(jsonString);
    } else {
      throw Exception('Unable to fetch data from the API');
    }
  } catch (e) {
    throw (e);
  }
}

Future<Map<String, dynamic>> pushToken(Map<String, dynamic> body) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}shopPushNotification';
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
      throw Exception('Unable to add push token from the REST API');
    }
  } catch (e) {
    throw (e);
  }
}


Future<List<Order>> getSearchedOrder(String pattern, String shop_ID) async
{
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}ShopLiveOrderSearch';
  final client = new http.Client();
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
      "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "keyword": pattern,
      "paging": "0",
      "shop_ID":shop_ID,
    });

    if (response.statusCode == 200) {


      return SearchedProductBase.fromMap(json.decode(response.body)).orders;

    }

    else {
      throw Exception('Unable to Fetch Categories');
    }
  } catch (e) {
    print(e);
    throw (e);
  }
}

Future<List<Order>> getSearchedCancelledOrder(String pattern, String shop_ID) async
{
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}ShopCancelledOrderSearch';
  final client = new http.Client();
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
      "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "keyword": pattern,
      "paging": "0",
      "shop_ID":shop_ID,
    });
print(response.statusCode);
    if (response.statusCode == 200) {

      print(SearchedProductBase.fromMap(json.decode(response.body)).orders);
      return SearchedProductBase.fromMap(json.decode(response.body)).orders;

    }

    else {
      throw Exception('Unable to Fetch Categories');
    }
  } catch (e) {
    print(e);
    throw (e);
  }
}

Future<List<Order>> getSearchedCompletedOrder(String pattern, String shop_ID) async
{
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}ShopDeliverdOrderSearch';
  final client = new http.Client();
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
      "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "keyword": pattern,
      "paging": "0",
      "shop_ID":shop_ID,
    });

    if (response.statusCode == 200) {

      print(response.body);
      return SearchedProductBase.fromMap(json.decode(response.body)).orders;

    }

    else {
      throw Exception('Unable to Fetch Categories');
    }
  } catch (e) {
    print(e);
    throw (e);
  }
}