import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/generated/l10n.dart';
import 'package:shappy_store_app/src/helpers/maps_util.dart';
import 'package:shappy_store_app/src/models/customer.dart';
import 'package:shappy_store_app/src/models/shop_category.dart';
import 'package:shappy_store_app/src/models/store.dart';
import 'package:shappy_store_app/src/repository/shop_data_repository.dart'
    as repos;
import 'package:toast/toast.dart';

class StoreDataController extends ControllerMVC {
  Store store;

  String imageLink;
  List<Customer> customers;
  List<StoreCategory> shopCategories = <StoreCategory>[];
  Set<Marker> allMarkers = {};
  Set<Polyline> polyLines = {};
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  CameraPosition cameraPosition = CameraPosition(
    target: LatLng(13.06, 80.24),
    zoom: 11.0,
  );
  MapsUtil mapsUtil = new MapsUtil();
  Completer<GoogleMapController> mapController = Completer();
  StoreDataController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  void waitForStoreData({String shopID}) async {
    await repos.getShopData(shopID).then((value) {
      if (value != null) {
        setState(() => store = value);
      } else {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).verify_your_internet_connection),
        ));
      }
    }).catchError((e) => Toast.show(e.toString(), context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM));
  }

  void listenForCustomers({String shopID, String page}) async {
    await repos
        .getShopCustomers(shopID, page)
        .then((value) {
          if (value != null && value.isNotEmpty) {
            if (customers == null)
              setState(() => customers = value);
            else
              for (Customer c in value)
                if (!c.isIn(customers)) setState(() => customers.add(c));
          } else {
            if (customers == null) setState(() => customers = <Customer>[]);
          }
        })
        .catchError((e) => Toast.show(e.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM))
        .whenComplete(() {
          // scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //   content: Text(message),
          // ));
        });
  }

  void waitUntilShopImageUpload(PickedFile _image) async {
    await repos.uploadShopImage(_image).then((value) async {
      if (value != null && value.success && value.status) {
        setState(() => store.imageURL = value.imageUrl);
        await repos.updateShopData(store.toMap()).then((value) {
          if (value != null && value["success"] && value["status"]) {
            print(value["message"]);
            Toast.show(value["message"], context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            waitForStoreData(shopID: store.storeID.toString());
          }
        });
      }
    });
  }

  void updateLocation(Map<String, dynamic> body) async {
    final Map<String, dynamic> stream = await repos.updateShopData(body);
    if (stream != null && stream["success"] && stream["status"]) {
      print(stream["message"]);
      Toast.show(stream["message"], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      waitForStoreData(shopID: body["shop_ID"]);
    }
    Navigator.of(context).pop();
  }

  void waitForShopCategories() async {
    await repos
        .getShopCategories()
        .then((value) {
          if (value != null && value.isNotEmpty)
            setState(() => shopCategories = value);
          else
            Toast.show("No Shop Categories", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        })
        .catchError((e) => Toast.show(e.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM))
        .whenComplete(() => Toast.show("Done", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM));
  }

  void updateStoreDetail(Map<String, dynamic> body) async {
    await repos
        .updateShopData(body)
        .then((value) {
          if (value != null && value["status"] && value["success"]) {
            waitForStoreData(shopID: body["shop_ID"]);
            Navigator.of(context).pop();
            Toast.show(value["message"], context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          } else
            Toast.show("Error", context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        })
        .catchError((e) => Toast.show(e, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM))
        .whenComplete(() => Toast.show("Done", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM));
  }
}
