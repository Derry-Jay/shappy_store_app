import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:shappy_store_app/src/controller/home_and_order_controller.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/helpers/bloc.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/models/user.dart';
import 'package:shappy_store_app/src/pages/orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/helpers/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  final RouteArgument routeArgument;

  HomePage({Key key, this.routeArgument}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends StateMVC<HomePage> with TickerProviderStateMixin {
  int orderTab;
  HomeAndOrderController _con;
  String text = '';
  String subject = '';
  List<String> imagePaths = [];
  AnimationController animationController;
  static var myFormat = new DateFormat('dd MMMM yyyy');
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();

  HomePageState() : super(HomeAndOrderController()) {
    _con = controller;
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    );
  }

  BoxDecoration myBoxDecoration1() {
    return BoxDecoration(
      color: Color(0xffE62337),
      borderRadius: BorderRadius.circular(8),
    );
  }

  void _showMyDialog() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: myBoxDecoration(),
              padding: EdgeInsets.all(20),
              child: QrImage(
                data: sharedPrefs.getString("spShopID"),
                version: QrVersions.auto,
                size: sqrt((pow(MediaQuery.of(context).size.height, 2) +
                        pow(MediaQuery.of(context).size.width, 2)) /
                    12.25),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              decoration: myBoxDecoration1(),
              child: TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.share_outlined, color: Colors.white),
                    Text(
                      'Share Your Store',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () {
                  Share.share(
                      'https://www.google.com/search?q=amazon+prime&rlz=1C1CHBD_enIN915IN915&oq=ama&aqs=chrome.1.0i131i433j0i433j69i57j69i60l5.3334j1j7&sourceid=chrome&ie=UTF-8');
                },
              ),
            )
          ],
        );
      },
    );
  }

  Widget _statusCard(BuildContext context, String count, String orderStatus,
      String bgColor, String txtColor) {
    return Flexible(
      child: InkWell(
        child: Card(
          elevation: 0,
          color: Helper.getColorFromHex(bgColor),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 100,
                horizontal: MediaQuery.of(context).size.width / 100),
            child: Center(
              child: Column(children: <Widget>[
                Text(count == null ? "" : count,
                    style: TextStyle(
                        fontSize: 22,
                        color: Helper.getColorFromHex(txtColor),
                        fontWeight: FontWeight.bold)),
                Text(
                  orderStatus == null ? "" : orderStatus,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )
              ]),
            ),
          ),
        ),
        onTap: () => setState(() {
          orderTab = orderStatus.endsWith("Finished")
              ? 2
              : (orderStatus.endsWith("Cancelled") ? 1 : 0);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => OrdersPage(orderTab)));
        }),
      ),
    );
  }

  void getData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    await _con.waitForHomePageData(shopID: sharedPrefs.getString("spShopID"));

  }

   Stream<LocalNotification> _notificationsStream;
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      getData();
    });
  }

  @override
  void initState() {
    callController();
    super.initState();
    _notificationsStream = NotificationsBloc.instance.notificationsStream;
    _notificationsStream.listen((notification) {
      getData();
      // TODO: Implement your logic here
      print('punny');
    });
  }

  void callController() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    if (widget.routeArgument.param)
      _con.pushNotificationControl({
        "shop_ID": widget.routeArgument.id,
        "device_token": sharedPrefs.getString("spDeviceToken"),
        "app_type": "0"
      });
    final r = await sharedPrefs.setBool("registered", true);
    final t = await sharedPrefs.setBool("logoutFlag", false);
    final s = await sharedPrefs.setInt("approvalStatus", 1);
    print(sharedPrefs.getBool("registered"));
    print(sharedPrefs.getInt("approvalStatus"));
    print(sharedPrefs.getString("spShopID"));
    print(sharedPrefs.getBool("logoutFlag"));
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    await _con.waitForHomePageData(shopID: widget.routeArgument.id);
  }

  Future<void> refreshList() async {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      key: _con.scaffoldKey,
      appBar: AppBar(
          elevation: 0,
          leading: Container(),
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            _con.homePageData == null
                ? ""
                : (_con.homePageData.shopName == null
                    ? ""
                    : _con.homePageData.shopName),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.notifications_none_outlined),
                onPressed: () =>
                    Navigator.of(context).pushNamed("/Notifications"))
          ]),
      backgroundColor: Color(0xfff3f2f2),
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 5.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.0),
              bottomLeft: Radius.circular(20.0),
            ),
            color: const Color(0xffe62136),
            boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 2),
                blurRadius: 15,
              ),
            ],
          ),
        ),
        _con.homePageData == null
            ? CircularLoadingWidget(
                height: MediaQuery.of(context).size.height / 10,
              )
            : RefreshIndicator(
                child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height / 100,
                              horizontal:
                                  MediaQuery.of(context).size.width / 70),
                          child: Card(
                              elevation: 0,
                              child: Column(
                                  children: <Widget>[
                                    Container(
                                        child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Last 30 days Revenue",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black),
                                                  ),
                                                  InkWell(
                                                    child: Image.asset(
                                                      'assets/img/Group 9681.png',
                                                    ),
                                                    onTap: _showMyDialog,
                                                  )
                                                ],
                                              ),
                                              Text(
                                                  _con.homePageData.revenue ==
                                                          null.toString()
                                                      ? "0"
                                                      : _con
                                                          .homePageData.revenue,
                                                  style: TextStyle(
                                                      color: Color(0xffe62136),
                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold))
                                            ],
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25.0,
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80)),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                40.0,
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            _statusCard(
                                                context,
                                                _con.homePageData.ordersPending
                                                    .toString(),
                                                "Order" +
                                                    (_con.homePageData
                                                                .ordersPending ==
                                                            1
                                                        ? ' '
                                                        : 's ') +
                                                    "Pending",
                                                "#fff9f2",
                                                "#ff870f"),
                                            _statusCard(
                                                context,
                                                _con.homePageData
                                                    .ordersCompleted
                                                    .toString(),
                                                "Order" +
                                                    (_con.homePageData
                                                                .ordersCompleted ==
                                                            1
                                                        ? ' '
                                                        : 's ') +
                                                    "Finished",
                                                "#f3faf2",
                                                "#52bb43"),
                                            _statusCard(
                                                context,
                                                _con.homePageData
                                                    .ordersCancelled
                                                    .toString(),
                                                "Order" +
                                                    (_con.homePageData
                                                                .ordersCancelled ==
                                                            1
                                                        ? ' '
                                                        : 's ') +
                                                    "Cancelled",
                                                "#fef4f5",
                                                "#e62337"),
                                          ],
                                        )),
                                  ],
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start))),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 60),
                        child: InkWell(
                            child: Card(
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                      child: Card(
                                        elevation: 0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                50),
                                        child: Center(
                                            child: Text(
                                                _con.homePageData == null
                                                    ? ""
                                                    : _con.homePageData
                                                        .ordersPendingForApproval
                                                        .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 40.0,
                                                  color: Colors.white,
                                                ))),
                                        color: Color(0xffe62136),
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height /
                                              7.5),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              50,
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              20),
                                      child: Center(
                                          child: _con.homePageData == null
                                              ? Text("")
                                              : Text(
                                                  'Order' +
                                                      (_con.homePageData
                                                                  .ordersPendingForApproval ==
                                                              1
                                                          ? ' '
                                                          : 's ') +
                                                      'Waiting\nFor Approval',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25.0,
                                                    color: Color(0xff4e4e4e),
                                                  )))),
                                ],
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrdersPage(0)))),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 190),
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 190),
                          child:
                          Column(children: [
                            Row(
                                children: [
                                  Card(
                                      elevation: 0,
                                      color: Color(0xffe62337),
                                      shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all (Radius.circular(10))),
                                      child: InkWell(
                                          child: Container(
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(100),
                                             ),
                                            height: MediaQuery.of(context).size.height/9,
                                              width: MediaQuery.of(context).size.height/5,
                                              child: Row(
                                                  children: [
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            8,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            15,
                                                        decoration: BoxDecoration(
                                                            image: DecorationImage(
                                                                image: AssetImage(
                                                                    "./assets/img/Group_9471.png"),
                                                                fit: BoxFit
                                                                    .contain))),
                                                    Text(
                                                      "Orders",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround),
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          60,
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          100)
                                          ),
                                          onTap: () => Navigator.of(context)
                                              .pushNamed("/Orders"))),
                                  Card(
                                    elevation: 0,
                                    color: Color(0xffe62337),
                                    child: InkWell(
                                        child: Container(
                                            height: MediaQuery.of(context).size.height/9,
                                            width: MediaQuery.of(context).size.height/4,
                                            child:
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              8,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              15,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  "./assets/img/Group_9473.png"),
                                                              fit: BoxFit
                                                                  .contain))),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text("Live",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center),
                                                      Text("Product",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 25,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center)
                                                    ],
                                                  ),
                                                ]),
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        200,
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100)
                                        ),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed("/Products_Status")),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all (Radius.circular(10))),
                                  )
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 100),
                            Row(
                                children: [
                                  Card(
                                    elevation: 0,
                                    child: InkWell(
                                        child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child: Icon(
                                                      Icons
                                                          .shopping_bag_outlined,
                                                      color: Color(0xffee6171),
                                                    ),
                                                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 80)),
                                                Text(
                                                  "Add Products",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ]),
                                          padding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height /
                                                  80,
                                              horizontal:
                                              MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width /
                                                  32),
                                        ),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed("/Products")),
                                  ),
                                  Card(
                                    elevation: 0,
                                    child: InkWell(
                                        child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child: Icon(
                                                        Icons
                                                            .people_alt_outlined,
                                                        color:
                                                            Color(0xffee6171)),
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height /
                                                            80,
                                                        horizontal:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                80)),
                                                Text(
                                                  "My Customers",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                      color: Colors.black),
                                                )
                                              ]),
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  8),
                                        ),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed("/Customers")),
                                  )
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly),
                            Row(
                                children: [
                                  Card(
                                    elevation: 0,
                                    child: InkWell(
                                        child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child: Icon(
                                                      Icons.store_outlined,
                                                      color: Color(0xffee6171),
                                                    ),
                                                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 50)),
                                                Text(
                                                  "My Store",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ]),
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                              MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width /
                                                  16,
                                              vertical: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height /
                                                  80),
                                        ),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed("/myStore")),
                                  ),
                                  Card(
                                    elevation: 0,
                                    child: InkWell(
                                        child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child: Image.asset(
                                                        "assets/img/accounts.png",
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                15,
                                                        height:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                27),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                50,
                                                        vertical:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .height /
                                                                150)),
                                                Text(
                                                  "Accounts",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13  ,
                                                      color: Colors.black),
                                                )
                                              ]),
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5.4),
                                        ),
                                        onTap: () => Navigator.of(context)
                                            .pushNamed("/salesData")),
                                  )
                                ],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly),
                            Container(
                              child: Row(children: [
                                Card(
                                    elevation: 0,
                                    child: InkWell(
                                        child: Container(
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                    child: Icon(
                                                        Icons.share_outlined,
                                                        color:
                                                            Color(0xffee6171)),
                                                    padding: EdgeInsets.only(right: MediaQuery.of(context).size.width / 80)),
                                                Text("Share Store",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13,
                                                        color: Colors.black),
                                                    softWrap: true)
                                              ]),
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                              MediaQuery.of(
                                                  context)
                                                  .size
                                                  .width /
                                                  16,
                                              vertical: MediaQuery.of(
                                                  context)
                                                  .size
                                                  .height /
                                                  100),
                                        ),
                                        onTap: () => Share.share(
                                            'https://www.google.com/search?q=amazon+prime&rlz=1C1CHBD_enIN915IN915&oq=ama&aqs=chrome.1.0i131i433j0i433j69i57j69i60l5.3334j1j7&sourceid=chrome&ie=UTF-8')))
                              ], mainAxisAlignment: MainAxisAlignment.start),
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width / 100,
                              ),
                            )
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween))
                    ]
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 60)),
                onRefresh: refreshList)
      ]),
    );
  }
}
