import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shappy_store_app/src/models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/controller/shop_data_controller.dart';

class StoreProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StoreProfilePageState();
}

class StoreProfilePageState extends StateMVC<StoreProfilePage> {
  String shopID;
  PickedFile image;
  StoreDataController _con;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  StoreProfilePageState() : super(StoreDataController()) {
    _con = controller;
  }

  void pickSessionData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    shopID = sharedPrefs.getString("spShopID");
    _con.waitForStoreData(shopID: shopID);
    _con.waitForShopCategories();
  }

  @override
  void initState() {
    pickSessionData();
    super.initState();
  }

  void navigateTo(String route, RouteArgument arguments) {
    Navigator.pushNamed(context, route, arguments: arguments).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      _con.waitForStoreData(shopID: shopID);
    });
  }

  @override
  Widget build(BuildContext context) {
    Store store = _con.store;
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Color(0xffe62136),
            centerTitle: true,
            title: Text("Store Profile"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Color(0xffe62136),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height / 80,
                    horizontal: MediaQuery.of(context).size.width / 20)),
            store == null
                ? CircularLoadingWidget(
                    height: MediaQuery.of(context).size.height / 1.25)
                : SingleChildScrollView(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 80,
                              horizontal:
                                  MediaQuery.of(context).size.width / 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Store Category",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                              Text(store.storeCat != null ? store.storeCat : "",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 80,
                              horizontal:
                                  MediaQuery.of(context).size.width / 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Store Name",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(
                                  store.storeName != null
                                      ? store.storeName
                                      : "",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 80,
                              horizontal:
                                  MediaQuery.of(context).size.width / 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Owner Name",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(
                                  store.ownerName != null
                                      ? store.ownerName
                                      : "",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500))
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 80,
                              horizontal:
                                  MediaQuery.of(context).size.width / 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Address/Location",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Text(
                                store.storeAddress.address != null
                                    ? store.storeAddress.address
                                    : "",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 80,
                              horizontal:
                                  MediaQuery.of(context).size.width / 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Store Images",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14)),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height /
                                              80),
                                  width: MediaQuery.of(context).size.width / 3,
                                  height:
                                      MediaQuery.of(context).size.height / 10,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(store.imageURL !=
                                                      null &&
                                                  store.imageURL != "" &&
                                                  store.imageURL != "null"
                                              ? store.imageURL
                                              : "https://shappyfiles.s3.amazonaws.com/Shopimages/1607680485438-%5Bobject%20Object%5D"))))
                            ],
                          )),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 80,
                            horizontal: MediaQuery.of(context).size.width / 20),
                        child: ButtonTheme(
                          minWidth: double.infinity,
                          height: MediaQuery.of(context).size.height / 16,
                          child: RaisedButton(
                            onPressed: () => navigateTo(
                                '/store_data_edit',
                                RouteArgument(id: "0", param: {
                                  "shop": _con.store,
                                  "categories": _con.shopCategories
                                })),
                            child: Text("Edit Shop"),
                            color: Color(0xffe62136),
                            textColor: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ))
          ],
        ),
        backgroundColor: Color(0xfff3f2f2));
  }
}
