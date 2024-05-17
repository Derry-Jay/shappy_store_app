import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shappy_store_app/src/models/address.dart';
import 'package:shappy_store_app/src/models/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/helpers/maps_util.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shappy_store_app/src/models/store_setting.dart';
import 'package:shappy_store_app/src/models/store_setting_base.dart';

Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
ValueNotifier<Address> deliveryAddress = new ValueNotifier(new Address());
final navigatorKey = GlobalKey<NavigatorState>();
//LocationData locationData;
Future<dynamic> setCurrentLocation() async {
  var location = new Location();
  MapsUtil mapsUtil = new MapsUtil();
  final whenDone = new Completer();
  Address _address = new Address();
  location.requestService().then((value) async {
    location.getLocation().then((_locationData) async {
      String _addressName = await mapsUtil.getAddressName(
          new LatLng(_locationData?.latitude, _locationData?.longitude),
          setting.value.googleMapsKey);
      _address = Address.fromJSON({
        'address': _addressName,
        'latitude': _locationData?.latitude,
        'longitude': _locationData?.longitude
      });
      //await changeCurrentLocation(_address);
      whenDone.complete(_address);
    }).timeout(Duration(seconds: 10), onTimeout: () async {
      //await changeCurrentLocation(_address);
      whenDone.complete(_address);
      return null;
    }).catchError((e) {
      whenDone.complete(_address);
    });
  });
  return whenDone.future;
}

Future<StoreSetting> getSettings(String shopID) async {
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
      return StoreSettingBase.fromMap(jsonString).settings;
    } else {
      throw Exception('Unable to fetch settings from the REST API');
    }
  } catch (e) {
    throw (e);
  }
}

Future<StoreSetting> updateCodStatus(String shopID, int codStat) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}shopCODUpdate';
  try {
    final response = await client.put(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID,
      "COD_status": codStat.toString()
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return StoreSettingBase.fromMap(jsonString).settings;
    } else {
      throw Exception('Unable to update settings to the REST API');
    }
  } catch (e) {
    throw (e);
  }
}

Future<StoreSetting> updateShopStatus(String shopID, int shopStat) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}shopStatusUpdate';
  try {
    final response = await client.put(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID,
      "shop_status": shopStat.toString()
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return StoreSettingBase.fromMap(jsonString).settings;
    } else {
      throw Exception('Unable to update settings to the REST API');
    }
  } catch (e) {
    throw (e);
  }
}

Future<StoreSetting> updateStorePickupStatus(
    String shopID, int storePickupStat) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}storepickupUpdate';
  try {
    final response = await client.put(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID,
      "store_pickupStatus": storePickupStat.toString()
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return StoreSettingBase.fromMap(jsonString).settings;
    } else {
      throw Exception('Unable to update settings to the REST API');
    }
  } catch (e) {
    throw (e);
  }
}

Future<StoreSetting> updateDeliveryRadius(
    String shopID, int deliverRadius) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}deliveryRadiusUpdate';
  try {
    final response = await client.put(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID,
      "delivery_radius": deliverRadius.toString()
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return StoreSettingBase.fromMap(jsonString).settings;
    } else {
      throw Exception('Unable to update settings to the REST API');
    }
  } catch (e) {
    throw (e);
  }
}
