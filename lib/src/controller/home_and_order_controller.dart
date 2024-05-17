import 'package:shappy_store_app/src/models/home.dart';
import 'package:shappy_store_app/src/repository/home_and_orders_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/models/order.dart';
import 'package:shappy_store_app/src/models/order_details.dart';
import 'package:shappy_store_app/src/repository/home_and_orders_repository.dart'
    as repository;

class HomeAndOrderController extends ControllerMVC {
  String shopID;
  Home homePageData;
  List<Order> liveOrder;
  OrderDetails orderDetails;
  List<Order> cancelledOrder;
  List<Order> searchedOrder = <Order>[];
  List<Order> searchedCancelledOrder = <Order>[];
  List<Order> searchedCompletedOrder = <Order>[];
  List<Order> deliveredOrder;
  GlobalKey<ScaffoldState> scaffoldKey;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  HomeAndOrderController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    getData();
  }

  void getData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    shopID = sharedPrefs.getString("spShopID");
  }

  Future<void> listenForLiveOrders({String shopId, String page}) async {
    final value = await repository.getLiveOrders(shopId, page);
    print("==============");
    print(value);
    if (value != null && value.isNotEmpty) {
      if (liveOrder == null)
        setState(() => liveOrder = value);
      else
        for (Order od in value)
          if (!od.isIn(liveOrder)) setState(() => liveOrder.add(od));
    } else {
      if (liveOrder == null) setState(() => liveOrder = <Order>[]);
    }
  }

  void listenForCancelOrders({String shopId, String page}) async {
    await repository.getCancelOrders(shopId, page).then((value) {
      if (value != null && value.isNotEmpty) {
        if (cancelledOrder == null)
          setState(() => cancelledOrder = value);
        else
          for (Order od in value)
            if (!od.isIn(cancelledOrder))
              setState(() => cancelledOrder.add(od));
      } else {
        if (cancelledOrder == null) setState(() => cancelledOrder = <Order>[]);
      }
    })
        // .catchError((e) => Toast.show(e.toString(), context,
        //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM))
        .whenComplete(() {
      // Helper.hideLoader(loader);
    });
  }

  void listenForDeliveredOrders({String shopId, String page}) async {
    await repository.getDeliveredOrders(shopId, page).then((value) {
      if (value != null && value.isNotEmpty) {
        if (deliveredOrder == null)
          setState(() => deliveredOrder = value);
        else
          for (Order od in value)
            if (!od.isIn(deliveredOrder))
              setState(() => deliveredOrder.add(od));
      } else {
        if (deliveredOrder == null) setState(() => deliveredOrder = <Order>[]);
      }
    })
        // .catchError((e) => Toast.show(e.toString(), context,
        //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM))
        .whenComplete(() {
      // Helper.hideLoader(loader);
    });
  }

  void cancelOrder({String cancelReason, int orderID, int index}) async {
    await repository.putCancelReason(cancelReason, orderID).then((value) async {
      if (value != null && value["success"] && value["status"]) {
        if (liveOrder != null && liveOrder.isNotEmpty)
          setState(() {
            liveOrder[index].orderStatus = 6;
            if (cancelledOrder == null)
              setState(() => cancelledOrder = <Order>[liveOrder[index]]);
            else
              cancelledOrder.add(liveOrder[index]);
          });
        print(value["message"]);
        Toast.show(value["message"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.pushNamed(context, "/Orders");
      }
    }).catchError((e) {
      print(e);
      Toast.show(e.toString(), context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }).whenComplete(() {
      // Helper.hideLoader(loader);
    });
  }

  void approveOrder({int orderID, int index}) async {
    await repository.approveOrder(orderID).then((value) async {
      if (value != null && value["success"] && value["status"]) {
        setState(() => liveOrder[index].orderStatus = 1);
        Toast.show("Order Approved Successfully", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  void deliverOrder(int orderID, {int index}) async {
    final Map stream = await repository.deliverOrder(orderID);
    final sharedPrefs = await _sharePrefs;
    if (stream != null && stream["success"] && stream["status"]) {
      print(stream["message"]);
      Toast.show(stream["message"], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      if (liveOrder != null && liveOrder.isNotEmpty) {
        setState(() {
          liveOrder[index].orderStatus = 5;
          if (deliveredOrder == null)
            deliveredOrder = <Order>[liveOrder[index]];
          else
            deliveredOrder.add(liveOrder[index]);
          liveOrder.removeAt(index);
        });
      } else {
        print(context.widget);
        await listenForLiveOrders(
            shopId: sharedPrefs.getString("spShopID"), page: "0");
        print(liveOrder);
        // listenForDeliveredOrders(
        //     shopId: sharedPrefs.getString("spShopID"), page: "0");
      }
      Navigator.of(context).pushNamed("/Orders");
    }
  }

  void waitForOrderDetails(String orderID) async {
    await repository.fetchOrderDetails(orderID).then((value) {
      if (value != null) {
        setState(() => orderDetails = value);
      } else {
        Toast.show("Cannot Fetch Order Details", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((e) => Toast.show(e.toString(), context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  Future<void> waitForHomePageData({String shopID}) async {
    await repository.getHomePageData(shopID: shopID).then((value) {
      if (value != null) {
        setState(() => homePageData = value);
      } else {
        // scaffoldKey?.currentState?.showSnackBar(SnackBar(
        //   content: Text(S.of(context).please_check_your_connection),
        // ));
      }
    }).catchError((e) => Toast.show(e.toString(), context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM));
  }

  void pushNotificationControl(Map<String, dynamic> body) async {
    await repository.pushToken(body).then((value) {
      if (value != null && value["success"]) {
        print(value);
        Toast.show(value["message"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    });
  }

  void waitForSearchedOrders(String pattern, String shop_ID) async {
    if (pattern == null || pattern == "") {
      print(searchedOrder);
      setState(() => searchedOrder = <Order>[]);
      // Toast.show("No Username Found", context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      final stream = await getSearchedOrder(pattern, shop_ID);
      if (stream != null) {
        print(stream);
        setState(() {
          searchedOrder = stream;
        });
        if (searchedOrder.isEmpty) {
          setState(() => searchedOrder = <Order>[]);
          // Toast.show("No Username Found", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      } else {
        setState(() => searchedOrder = <Order>[]);
        // Toast.show("No Username Found", context,
        //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }
  }

  void waitForCancelledOrders(String pattern, String shop_ID) async {
    if (pattern == null || pattern == "") {
      setState(() => searchedCancelledOrder = <Order>[]);
      // Toast.show("No Username Found", context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      final stream = await getSearchedCancelledOrder(pattern, shop_ID);
      if (stream != null) {
        setState(() => searchedCancelledOrder = stream);
        if (searchedCompletedOrder.isEmpty) {
          setState(() => searchedCompletedOrder = <Order>[]);
          // Toast.show("No Username Found", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      } else {
        setState(() => searchedCancelledOrder = <Order>[]);
        // Toast.show("No Username Found", context,
        //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }
  }

  void waitForCompletedOrders(String pattern, String shop_ID) async {
    if (pattern == null || pattern == "") {
      print(searchedOrder);
      setState(() => searchedCompletedOrder = <Order>[]);
      // Toast.show("No Username Found", context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    } else {
      final stream = await getSearchedCompletedOrder(pattern, shop_ID);
      if (stream != null) {
        print(stream);
        print('compl');
        setState(() => searchedCompletedOrder = stream);
        if (searchedCompletedOrder.isEmpty) {
          setState(() => searchedCompletedOrder = <Order>[]);
          // Toast.show("No Username Found", context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        }
      } else {
        setState(() => searchedCompletedOrder = <Order>[]);
        // Toast.show("No Username Found", context,
        //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      }
    }
  }
}
