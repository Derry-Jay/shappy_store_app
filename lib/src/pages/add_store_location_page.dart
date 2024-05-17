import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/models/store.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shappy_store_app/src/elements/BlockButtonWidget.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/controller/shop_data_controller.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StoreLocationPage extends StatefulWidget {
  final RouteArgument rar;
  StoreLocationPage(this.rar);
  @override
  State<StatefulWidget> createState() => StoreLocationPageState();
}

class StoreLocationPageState extends StateMVC<StoreLocationPage> {
  var location = Location();
  Store store;
  StoreDataController _con;
  BitmapDescriptor destIcon;
  Set<Marker> _markers = {};
  String lat = "13", long = "80";
  LatLng currentPosition;
  PanelController sc = new PanelController();
  TextEditingController addCon = new TextEditingController();
  TextEditingController areaCon = new TextEditingController();
  TextEditingController lamaCon = new TextEditingController();
  TextEditingController shopNoCon = new TextEditingController();
  StoreLocationPageState() : super(StoreDataController()) {
    _con = controller;
  }
  int Panelval;

  panel(){
if(Panelval == 0){
  setState(() {
    Panelval ==1;
  });
}
else if(Panelval == 1){
  setState(() {
    Panelval ==0;
  });
}
  }

  Future _checkGps() async {
    if (!await location.serviceEnabled()) {
      location.requestService();
      var position = await Geolocator.getCurrentPosition();
      setState(() =>
          currentPosition = LatLng(position.latitude, position.longitude));
    } else if (await location.serviceEnabled()) {
      var position = await Geolocator.getCurrentPosition();
      setState(() =>
          currentPosition = LatLng(position.latitude, position.longitude));
    }
  }

  @override
  void initState() {

    _checkGps();
    store = widget.rar.param["shop"];
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(50, 50)), 'assets/img/lmk.png')
        .then((onValue) => destIcon = onValue);
    shopNoCon.text = store.storeName != null ? store.storeName : "";
    areaCon.text =
        store.storeAddress.area != null ? store.storeAddress.area : "";
    addCon.text =
        store.storeAddress.address != null ? store.storeAddress.address : "";
    lamaCon.text =
        store.storeAddress.landMark != null ? store.storeAddress.landMark : "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _markers.add(Marker(
        markerId: MarkerId("store_address"),
        icon: destIcon,
        position:
            LatLng(store.storeAddress.latitude, store.storeAddress.longitude),
        draggable: true));
    return Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: <Widget>[
          _con.cameraPosition == null
              ? CircularLoadingWidget(height: 0)
              : GoogleMap(
                  markers: _markers,
                  mapToolbarEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: _con.cameraPosition,
                  gestureRecognizers: Set()
                    ..add(Factory<EagerGestureRecognizer>(
                        () => EagerGestureRecognizer())),
                  onMapCreated: (GoogleMapController controller) {
                    _con.mapController.complete(controller);
                  },
                  onCameraMove: (CameraPosition cameraPosition) {
                    _con.cameraPosition = cameraPosition;
                  },
                  onTap: (atOn) async {
                    setState(() => _markers.add(Marker(
                        markerId: MarkerId("store_address"),
                        icon: destIcon,
                        position: atOn,
                        draggable: true)));
                    var addresses = await Geocoder.local
                        .findAddressesFromCoordinates(
                            Coordinates(atOn.latitude, atOn.longitude));
                    var first = addresses.first;
                    lat = atOn.latitude.toString();
                    long = atOn.longitude.toString();
                    addCon.text = first.featureName +
                        ", " +
                        (first.thoroughfare != null
                            ? first.thoroughfare
                            : first.subLocality);
                    areaCon.text = first.subLocality;
                    Toast.show(
                        first.featureName +
                            ", " +
                            (first.thoroughfare != null
                                ? first.thoroughfare
                                : first.subLocality),
                        context,
                        duration: Toast.LENGTH_LONG,
                        gravity: Toast.BOTTOM);
                  },
                  polylines: _con.polyLines,
                ),
          Container(
            child: SlidingUpPanel(
          defaultPanelState:PanelState.OPEN,
              panel: SingleChildScrollView(
                  child: Form(
                    key: _con.loginFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          //first container
                          height: MediaQuery.of(context).size.height / 20,
                          width: MediaQuery.of(context).size.width / 5,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height / 30),
                            child: RaisedButton(
                                color: Colors.white,
                                onPressed: ()  {

                                  panel();
                                  print(Panelval);

                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0))),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 10),
                        TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                            validator: (input) => input.length != 3
                                ? "Enter the store name, minimum 3 character"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Shop Name",
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              //prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                            controller: shopNoCon),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 50),
                        TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                            validator: (input) => input.length != 3
                                ? "Enter the owner name,minimum 3 character"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Address",
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              //prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                            controller: addCon),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 50),
                        TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                            validator: (input) => input.length != 3
                                ? "Enter the name, minimum 3 character"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Area",
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              //prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                            controller: areaCon),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 50),
                        TextFormField(
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            onFieldSubmitted: (v) {
                              FocusScope.of(context).nextFocus();
                            },
                            validator: (input) => input.length != 3
                                ? "Enter the name,minimum 3 character"
                                : null,
                            decoration: InputDecoration(
                              labelText: "Landmark",
                              labelStyle: TextStyle(
                                  color: Theme.of(context).accentColor),
                              contentPadding: EdgeInsets.all(12),
                              //prefixIcon: Icon(Icons.phone, color: Theme.of(context).accentColor),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.5))),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.2))),
                            ),
                            controller: lamaCon),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 50),
                        BlockButtonWidget(
                          text: Text(
                            "Update Location",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).accentColor,
                          onPressed: () {
                            Map<String, dynamic> prm = {
                              "shop_ID": store.storeID.toString(),
                              "landmark":
                                  lamaCon.text != null ? lamaCon.text : "",
                              "area": areaCon.text,
                              "address": addCon.text,
                              "lat": lat,
                              "lon": long
                            };
                            _con.updateLocation(prm);
                            Navigator.of(context).pop();
                          },
                        ),
                        // SizedBox(height: MediaQuery.of(context).size.height / 100),
                      ],
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 100,
                      horizontal: MediaQuery.of(context).size.width / 25)),
              controller: sc,
                onPanelOpened:(){
                  setState(() {
                    Panelval = 0;
                    print(Panelval);
                  });
                },
                    onPanelClosed:(){
                      setState(() {
                        Panelval = 1;
                        print(Panelval);
                               });
                           }

            ),
          )
        ],
      ),
    );
  }
}
