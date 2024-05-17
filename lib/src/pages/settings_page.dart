import 'dart:async';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shappy_store_app/src/controller/settings_controller.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends StateMVC<SettingsPage> {
  int radius;
  String shopID;
  LatLng center;
  Set<Circle> circles;
  SettingsController _con;
  Set<Marker> markers = {};
  BitmapDescriptor destIcon;
  Completer<GoogleMapController> _controller = Completer();
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  SettingsPageState() : super(SettingsController()) {
    _con = controller;
  }

  void pickSessionData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    destIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50, 50)), 'assets/img/lmk.png');
    shopID = sharedPrefs.getString("spShopID");
    _con.waitForSettings(shopID: shopID);
  }

  void initState() {
    pickSessionData();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  Widget build(BuildContext context) {
    int rad = _con.settings != null ? _con.settings.deliverRadius : 0,
        id = _con.settings != null ? _con.settings.shopID : 0;
    double lat = _con.settings != null ? double.parse(_con.settings.lat) : 0.0,
        long = _con.settings != null ? double.parse(_con.settings.long) : 0.0;
    center = LatLng(lat, long);
    markers.add(Marker(
        markerId: MarkerId("destPin"), position: center, icon: destIcon));
    circles = Set.from([
      Circle(
          fillColor: Color(0x11e62136),
          strokeColor: Color(0xffe62136),
          circleId: CircleId(id.toString()),
          center: center,
          radius: (rad * 1000).toDouble(),
          strokeWidth: 1)
    ]);
    return Scaffold(
      // backgroundColor: Color(0xfff3f2f2), LatLng(double.parse(_con.settings.lat), double.parse(_con.settings.long))
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xffe62136),
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Color(0xffe62136),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              padding: EdgeInsets.all(10)),
          _con.settings == null
              ? CircularLoadingWidget(
                  height: 100,
                )
              : Expanded(
                  child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 0,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Store Live",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              Flexible(
                                  child: Switch(
                                activeColor: Color(0xff57c901),
                                activeTrackColor: Color(0xff57c901),
                                inactiveThumbColor: Color(0xffe62337),
                                inactiveTrackColor: Color(0xffe62337),
                                value: _con.settings.shopStatus == 1,
                                onChanged: (boolean) {
                                  _con.setShopStatus(
                                      shopID: shopID,
                                      shopStat: _con.settings.shopStatus);
                                  Toast.show(
                                      "Store made " +
                                          (boolean ? "Live" : "Unlive"),
                                      context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                },
                              ))
                            ],
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                      ),
                      Card(
                          elevation: 0,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Cash On Delivery",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                Switch(
                                  activeColor: Color(0xff57c901),
                                  activeTrackColor: Color(0xff57c901),
                                  inactiveThumbColor: Color(0xffe62337),
                                  inactiveTrackColor: Color(0xffe62337),
                                  value: _con.settings.codStatus == 1,
                                  onChanged: (boolean) {
                                    _con.setCodStatus(
                                        shopID: shopID,
                                        codStat: _con.settings.codStatus);
                                  },
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                          )),
                      Card(
                          elevation: 0,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Store Pickup",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                Switch(
                                  activeColor: Color(0xff57c901),
                                  activeTrackColor: Color(0xff57c901),
                                  inactiveThumbColor: Color(0xffe62337),
                                  inactiveTrackColor: Color(0xffe62337),
                                  value: _con.settings.storePickupStatus == 1,
                                  onChanged: (boolean) {
                                    _con.setStorePickupStatus(
                                        shopID: shopID,
                                        storePickupStat:
                                            _con.settings.storePickupStatus);
                                  },
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                          )),
                      Card(
                          elevation: 0,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery Radius",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                Row(
                                  children: [
                                    DropdownButton<String>(
                                      value: _con.settings.deliverRadius
                                          .toString(),
                                      icon: Icon(Icons.arrow_downward,
                                          color: Color(0xffe62136)),
                                      iconSize: 24,
                                      elevation: 16,
                                      style: TextStyle(color: Colors.black),
                                      underline: Container(
                                        height: 2,
                                        color: Colors.white,
                                      ),
                                      onChanged: (String newValue) {
                                        radius = int.parse(newValue);
                                        _con.setDeliveryRadius(
                                            shopID: shopID,
                                            deliverRadius: radius);
                                      },
                                      items: <String>['1', '2', '3', '4', '5']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    Text("KM",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17))
                                  ],
                                )
                              ],
                            ),
                            padding: EdgeInsets.all(10),
                          ))
                    ],
                  ),
                )),
          _con.settings == null
              ? CircularLoadingWidget(
                  height: 100,
                )
              : Expanded(
                  child: GoogleMap(
                      circles: circles,
                      compassEnabled: true,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition:
                      CameraPosition(target: center, zoom: 12.0), //,
                      markers: markers))
        ],
      ),
    );
  }
}
