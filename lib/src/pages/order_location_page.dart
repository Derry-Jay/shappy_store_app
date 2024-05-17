import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shappy_store_app/src/models/order.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/controller/home_and_order_controller.dart';

class OrderLocationPage extends StatefulWidget {
  final RouteArgument rar;
  OrderLocationPage(this.rar);
  @override
  OrderLocationPageState createState() => OrderLocationPageState();
}

class OrderLocationPageState extends StateMVC<OrderLocationPage> {
  int index;
  Order order;
  HomeAndOrderController _con;
  Set<Marker> _markers = {};
  BitmapDescriptor destIcon;
  LatLng _center;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  Completer<GoogleMapController> _controller = Completer();
  OrderLocationPageState() : super(HomeAndOrderController()) {
    _con = controller;
  }

  void getData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'assets/img/lmk.png')
        .then((onValue) {
      destIcon = onValue;
    });
    _con.listenForLiveOrders(shopId: sharedPrefs.getString("spShopID"));
    _con.listenForDeliveredOrders(shopId: sharedPrefs.getString("spShopID"));
  }

  void setDestPin() {
    setState(() {
      _center = LatLng(double.parse(order.lat), double.parse(order.lng));
      _markers.add(Marker(
          markerId: MarkerId("destPin"), position: _center, icon: destIcon));
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setDestPin();
  }

  @override
  void initState() {
    order = widget.rar.param;
    index = int.parse(widget.rar.id);
    _center = LatLng(double.parse(order.lat), double.parse(order.lng));
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            title: Text('Order No. #' + widget.rar.heroTag,
                style: TextStyle(
                    color: Color(0xffe62136),
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.of(context).pop())),
        body: Stack(
          children: [
            Container(
                child: GoogleMap(
              markers: _markers,
              compassEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 14.0,
              ),
            )),
            Column(children: [
              Container(
                  child: Column(
                    children: [
                      Row(children: [
                        Text(order.userName + ", " + order.area,
                            style:
                                TextStyle(color: Colors.black, fontSize: 17)),
                        OutlineButton(
                            borderSide: BorderSide(color: Colors.black),
                            onPressed: () async {
                              final url =
                                  "https://www.google.com/maps/search/?api=1&query=${order.lat},${order.lng}";
                              final flag = await canLaunch(url);
                              if (flag)
                                launch(url);
                              else
                                Toast.show("Cannot Go to Map", context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text('Go To Map'),
                            color: Colors.black54,
                            textColor: Colors.black54)
                      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      Row(children: [
                        Text("₹ " + order.total,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        OutlineButton(
                            borderSide: BorderSide(color: Colors.black),
                            onPressed: () => launch("tel://" + order.phNo),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text('Call'),
                            color: Colors.black54,
                            textColor: Colors.black54)
                      ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      InkWell(
                          child: Text("Product Details",
                              style: TextStyle(
                                  color: Color(0xffe62136), fontSize: 17)),
                          onTap: () => Navigator.of(context).pushNamed(
                              '/order_details',
                              arguments: RouteArgument(
                                  param: order, id: order.orderID.toString())))
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  padding: EdgeInsets.all(15)),
              Container(
                  child: RaisedButton(
                      onPressed: () =>
                          _con.deliverOrder(order.orderID, index: index),
                      child: Text("Deliver \u2192",
                          style: TextStyle(color: Colors.white, fontSize: 19)),
                      color: Color(0xffe62136)),
                  width: MediaQuery.of(context).size.width / 1.35,
                  height: MediaQuery.of(context).size.height / 10,
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 100,
                      vertical: MediaQuery.of(context).size.height / 40))
            ], mainAxisAlignment: MainAxisAlignment.spaceBetween)
          ],
          alignment: Alignment.topRight,
        ));
  }
}
