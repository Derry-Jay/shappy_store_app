import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/models/store_setting.dart';
import 'package:shappy_store_app/src/repository/settings_repository.dart'
    as repos;
import 'package:toast/toast.dart';

class SettingsController extends ControllerMVC {
  StoreSetting settings;
  GlobalKey<ScaffoldState> scaffoldKey;
  SettingsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  void waitForSettings({String shopID}) async {
    await repos.getSettings(shopID).then((value) {
      if (value != null)
        setState(() => settings = value);
      else
        Toast.show("Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void setCodStatus({String shopID, int codStat}) async {
    int temp = codStat == 1 ? codStat - 1 : codStat + 1;
    await repos.updateCodStatus(shopID, temp).then((value) {
      if (value != null)
        waitForSettings(shopID: shopID);
      else
        Toast.show("Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void setShopStatus({String shopID, int shopStat}) async {
    int temp = shopStat == 1 ? shopStat - 1 : shopStat + 1;
    await repos.updateShopStatus(shopID, temp).then((value) {
      if (value != null)
        waitForSettings(shopID: shopID);
      else
        Toast.show("Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void setStorePickupStatus({String shopID, int storePickupStat}) async {
    int temp = storePickupStat == 1 ? storePickupStat - 1 : storePickupStat + 1;
    await repos.updateStorePickupStatus(shopID, temp).then((value) {
      if (value != null)
        waitForSettings(shopID: shopID);
      else
        Toast.show("Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void setDeliveryRadius({String shopID, int deliverRadius}) async {
    await repos.updateDeliveryRadius(shopID, deliverRadius).then((value) {
      if (value != null) {
        waitForSettings(shopID: shopID);
        Toast.show("Delivery Radius Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else
        Toast.show("Error", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e.toString(), context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }
}
