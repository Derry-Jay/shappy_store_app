import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shappy_store_app/src/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/controller/home_and_order_controller.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';

class OrdersPage extends StatefulWidget {
  final int specificPage;
  OrdersPage(this.specificPage);
  @override
  State<StatefulWidget> createState() => OrdersPageState(this.specificPage);
}

class OrdersPageState extends StateMVC<OrdersPage>
    with TickerProviderStateMixin {
  String shopID;
  TabController tabCon;
  HomeAndOrderController _con;
  int specificPage, pageNoLive, pageNoComp, pageNoCan;
  TextEditingController crc = new TextEditingController();
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  OrdersPageState(this.specificPage) : super(HomeAndOrderController()) {
    _con = controller;
  }
  ScrollController cont;
  int searchindex = 0;
  int listindex = 0;
  TextEditingController kc = new TextEditingController();

  Future<bool> _onWillPop() async {
    if (searchindex == 1) {
      setState(() {
        searchindex = 0;
        listindex = 0;
      });
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, "/Home", (Route<dynamic> route) => false);
    }
    return Future.value(false);
  }

  void getData() async {
    setState(() {
      pageNoLive = 0;
      pageNoComp = 0;
      pageNoCan = 0;
    });
    if (specificPage == 0) {
      await _con.listenForLiveOrders(
          shopId: shopID, page: pageNoLive.toString());
      print("|-|-|-|-|-|-|-|-|-|-|-|-|-|");
      print(_con.liveOrder);
      print("-|-|-|-|-|-|-|-|-|-|-|-|-|-|");
    }
  }

  void pickSessionData() async {
    pageNoLive = 0;
    pageNoComp = 0;
    pageNoCan = 0;
    tabCon = new TabController(length: 3, vsync: this, initialIndex: 0);
    final SharedPreferences sharedPrefs = await _sharePrefs;
    shopID = sharedPrefs.getString("spShopID");
    _con.listenForLiveOrders(shopId: shopID, page: pageNoLive.toString());
    _con.listenForCancelOrders(shopId: shopID, page: pageNoCan.toString());
    _con.listenForDeliveredOrders(shopId: shopID, page: pageNoComp.toString());
  }

  FutureOr onGoBack(dynamic value) async {
    setState(() {
      pageNoLive = 0;
      pageNoComp = 0;
      pageNoCan = 0;
    });
    if (specificPage == 0) {
      await _con.listenForLiveOrders(
          shopId: shopID, page: pageNoLive.toString());
      // print("|-|-|-|-|-|-|-|-|-|-|-|-|-|");
      // print(_con.liveOrder);
      // print("-|-|-|-|-|-|-|-|-|-|-|-|-|-|");
    } else if (specificPage == 1)
      _con.listenForCancelOrders(shopId: shopID, page: pageNoCan.toString());
    else
      _con.listenForDeliveredOrders(
          shopId: shopID, page: pageNoComp.toString());
  }

  void navigateTo(String route, RouteArgument arguments) {
    Navigator.pushNamed(context, route, arguments: arguments).then(onGoBack);
  }

  Future<void> _refreshLocalGallery() async {
    if (specificPage == 0)
      await _con.listenForLiveOrders(shopId: shopID, page: "0");
    else if (specificPage == 1)
      _con.listenForCancelOrders(shopId: shopID, page: "0");
    else
      _con.listenForDeliveredOrders(shopId: shopID, page: "0");
  }

  void _scrollListener() {
    if (cont.position.pixels == cont.position.maxScrollExtent) {
      setState(() {
        if (specificPage == 0) {
          pageNoLive += 1;
          print(pageNoLive);
          _con.listenForLiveOrders(shopId: shopID, page: pageNoLive.toString());
        } else if (specificPage == 1) {
          pageNoCan += 1;
          _con.listenForCancelOrders(
              shopId: shopID, page: pageNoCan.toString());
          print(_con.cancelledOrder.length);
        } else {
          pageNoComp += 1;
          print(pageNoComp);
          _con.listenForDeliveredOrders(
              shopId: shopID, page: pageNoComp.toString());
        }
      });
    }
  }

  @override
  void initState() {
    pickSessionData();
    super.initState();
    cont = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() async {
    cont.removeListener(_scrollListener);
    kc.clear();
    super.dispose();
  }

  Widget ordersBoxList(List<Order> items) {
    if (listindex == 0) {
      return RefreshIndicator(
          child: ListView.builder(
              itemCount: items.length + 1,
              controller: cont,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) => index ==
                      items.length
                  ? (items.length < 10
                      ? Container(height: 0, width: 0)
                      : CircularLoadingWidget(height: 30))
                  : InkWell(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 40),
                        child: Card(
                          elevation: 0,
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 30,
                                vertical:
                                    MediaQuery.of(context).size.height / 80),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '#' + items[index].orderID.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17),
                                        ),
                                        Text(items[index].userName,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17)),
                                        Text(items[index].area,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17))
                                      ],
                                    ),
                                    Flexible(
                                        flex: 3,
                                        fit: FlexFit.tight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                "₹" +
                                                    items[index]
                                                        .total
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17)),
                                            Container(
                                                child: InkWell(
                                                  onTap: () => navigateTo(
                                                      '/order_details',
                                                      RouteArgument(
                                                          param: items[index],
                                                          id: index
                                                              .toString())),
                                                  child: Text('Details \u2192',
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color(
                                                              0xffe62136))),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 6)),
                                            Visibility(
                                              visible:
                                                  items[index].orderStatus == 0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  RaisedButton(
                                                    onPressed: () {
                                                      _showDialog(items, index);
                                                    },
                                                    child: Text('Cancel'),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            30,
                                                  ),
                                                  RaisedButton(
                                                    onPressed: () =>
                                                        _con.approveOrder(
                                                            orderID:
                                                                items[index]
                                                                    .orderID,
                                                            index: index),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    child: Text(
                                                      'Approve',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    color: Color(0xffe62136),
                                                    textColor: Colors.white,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                Visibility(
                                  visible: items[index].orderStatus != 0 &&
                                      items[index].orderStatus != 5 &&
                                      items[index].orderStatus != 6,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                150,
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                25),
                                        decoration: BoxDecoration(
                                            color: Color(0xffe62136),
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20.0),
                                                bottomRight:
                                                    Radius.circular(20.0))),
                                        child: Text(
                                          items[index].paymentType == 0
                                              ? 'COD'
                                              : 'Store Pickup',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Flexible(
                                        fit: FlexFit.tight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Visibility(
                                                visible: items[index]
                                                        .paymentType ==
                                                    0,
                                                child: OutlineButton(
                                                    onPressed: () => navigateTo(
                                                        "/order_location",
                                                        RouteArgument(
                                                            id: index
                                                                .toString(),
                                                            heroTag:
                                                                items[index]
                                                                    .orderID
                                                                    .toString(),
                                                            param:
                                                                items[index])),
                                                    child: Text('Navigate'),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0)),
                                                    color: Colors.black54,
                                                    textColor: Colors.black54)),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  15,
                                            ),
                                            OutlineButton(
                                              onPressed: () => launch(
                                                  "tel://" + items[index].phNo),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                              child: Text('Call'),
                                              color: Colors.black54,
                                              textColor: Colors.black54,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: () => navigateTo(
                          '/order_details',
                          RouteArgument(
                              param: items[index], id: index.toString())))),
          onRefresh: _refreshLocalGallery);
    } else {
      final orders = specificPage == 2
          ? _con.searchedCompletedOrder
          : (specificPage == 1
              ? _con.searchedCancelledOrder
              : _con.searchedOrder);
      return ListView.builder(
          itemCount: orders.length + 1,
          controller: cont,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) => index ==
                  orders.length
              ? (orders.length < 10
                  ? Container(height: 0, width: 0)
                  : CircularLoadingWidget(height: 30))
              : InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 40),
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 30,
                            vertical: MediaQuery.of(context).size.height / 80),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '#' + orders[index].orderID.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                    Text(orders[index].userName,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17)),
                                    Text(orders[index].area,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 17))
                                  ],
                                ),
                                Flexible(
                                    flex: 3,
                                    fit: FlexFit.tight,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                            "₹" +
                                                orders[index].total.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17)),
                                        Container(
                                            child: InkWell(
                                              onTap: () => navigateTo(
                                                  '/order_details',
                                                  RouteArgument(
                                                      param: orders[index],
                                                      id: index.toString())),
                                              child: Text('Details \u2192',
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          Color(0xffe62136))),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 6)),
                                        Visibility(
                                          visible:
                                              orders[index].orderStatus == 0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              RaisedButton(
                                                onPressed: () {
                                                  _showDialog(items, index);
                                                },
                                                child: Text('Cancel'),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    30,
                                              ),
                                              RaisedButton(
                                                onPressed: () =>
                                                    _con.approveOrder(
                                                        orderID: items[index]
                                                            .orderID,
                                                        index: index),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                child: Text(
                                                  'Approve',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                color: Color(0xffe62136),
                                                textColor: Colors.white,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                            Visibility(
                              visible: orders[index].orderStatus != 0 &&
                                  orders[index].orderStatus != 5 &&
                                  orders[index].orderStatus != 6,
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height /
                                                150,
                                        horizontal:
                                            MediaQuery.of(context).size.width /
                                                25),
                                    decoration: BoxDecoration(
                                        color: Color(0xffe62136),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.0),
                                            bottomRight:
                                                Radius.circular(20.0))),
                                    child: Text(
                                      orders[index].paymentType == 0
                                          ? 'COD'
                                          : 'Store Pickup',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.tight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Visibility(
                                            visible:
                                                orders[index].paymentType == 0,
                                            child: OutlineButton(
                                                onPressed: () => navigateTo(
                                                    "/order_location",
                                                    RouteArgument(
                                                        id: index.toString(),
                                                        heroTag: orders[index]
                                                            .orderID
                                                            .toString(),
                                                        param: items[index])),
                                                child: Text('Navigate'),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0)),
                                                color: Colors.black54,
                                                textColor: Colors.black54)),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              15,
                                        ),
                                        OutlineButton(
                                          onPressed: () => launch(
                                              "tel://" + orders[index].phNo),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Text('Call'),
                                          color: Colors.black54,
                                          textColor: Colors.black54,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () => navigateTo(
                      '/order_details',
                      RouteArgument(
                          param: items[index], id: index.toString()))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: DefaultTabController(
            initialIndex: specificPage != null ? specificPage : 0,
            length: 3,
            child: Builder(
              builder: (context) {
                tabCon = DefaultTabController.of(context);
                tabCon.addListener(() {
                  setState(() {
                    specificPage = tabCon.index;
                    searchindex = 0;
                    listindex = 0;
                    kc.clear();
                  });
                });
                return Scaffold(
                    key: _con.scaffoldKey,
                    appBar: AppBar(
                      backgroundColor: Color(0xffe62136),
                      centerTitle: true,
                      title: searchindex == 1
                          ? TextField(
                              autofocus: true,
                              cursorColor: Colors.black,
                              controller: kc,
                              onChanged: (pattern) => specificPage == 2
                                  ? _con.waitForCompletedOrders(pattern, shopID)
                                  : specificPage == 1
                                      ? _con.waitForCancelledOrders(
                                          pattern, shopID)
                                      : _con.waitForSearchedOrders(
                                          pattern, shopID),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.search),
                                contentPadding: EdgeInsets.all(12),
                                hintText: 'Search in Orders',
                                hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.2)),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.2))),
                              ))
                          : Container(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width / 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Orders',
                                  ),
                                  IconButton(
                                    icon:
                                        Icon(Icons.search, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        searchindex = 1;
                                        listindex = 1;
                                        kc.clear();
                                        print(specificPage);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          if (searchindex == 1) {
                            setState(() {
                              searchindex = 0;
                              listindex = 0;
                            });
                          } else {
                            Navigator.pushNamedAndRemoveUntil(context, "/Home",
                                (Route<dynamic> route) => false);
                          }
                        },
                      ),
                      // actions: <Widget>[
                      //   IconButton(
                      //       icon: Icon(Icons.search),2
                      //       onPressed: () {
                      //         print('search icon');
                      //       })
                      // ],
                      bottom: TabBar(
                        indicatorColor: Colors.white,
                        tabs: [
                          Tab(
                            text: 'Live',
                          ),
                          Tab(text: 'Cancelled'),
                          Tab(text: 'Completed')
                        ],
                        onTap: (idx) => setState(() {
                          specificPage = idx;
                          searchindex = 0;
                          listindex = 0;
                          kc.clear();
                        }),
                      ),
                    ),
                    body: TabBarView(
                      controller: tabCon,
                      children: [
                        _con.liveOrder == null
                            ? CircularLoadingWidget(
                                height: MediaQuery.of(context).size.height)
                            : (_con.liveOrder.length != 0
                                ? ordersBoxList(_con.liveOrder)
                                : Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/empty_live_orders.png"))),
                                    height: MediaQuery.of(context).size.height /
                                        20)),
                        _con.cancelledOrder == null
                            ? CircularLoadingWidget(
                                height: MediaQuery.of(context).size.height)
                            : (_con.cancelledOrder.length != 0
                                ? ordersBoxList(_con.cancelledOrder)
                                : Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/empty_cancelled_orders.png"))),
                                    height: MediaQuery.of(context).size.height /
                                        20)),
                        _con.deliveredOrder == null
                            ? CircularLoadingWidget(
                                height: MediaQuery.of(context).size.height)
                            : (_con.deliveredOrder.length != 0
                                ? ordersBoxList(_con.deliveredOrder)
                                : Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/empty_delivered_orders.png"))),
                                    height: MediaQuery.of(context).size.height /
                                        20)),
                      ],
                    ),
                    // floatingActionButton: FloatingActionButton(
                    //   onPressed: () {
                    //     print('MI<->DC');
                    //   },
                    //   tooltip: 'Filter',
                    //   child: Icon(Icons.filter_alt_outlined),
                    // ),
                    backgroundColor: Color(0xfff3f2f2));
              },
            )),
        onWillPop: _onWillPop);
  }

  void _showDialog(List<Order> items, int index) async {
    await showDialog<String>(
      context: context,
      child: _SystemPadding(
        child: new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  onSubmitted: (val) => setState(() => crc.text = val),
                  controller: crc,
                  decoration: new InputDecoration(
                      labelText: 'Cancel Reason',
                      hintText: 'eg. Duplicate Order'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Color(0xffe62136)),
                ),
                onPressed: () async {
                  _con.cancelOrder(
                      cancelReason: crc.text,
                      orderID: items[index].orderID,
                      index: index);
                  setState(() => items.removeAt(index));
                  _con.listenForLiveOrders(shopId: shopID);
                  _con.listenForCancelOrders(shopId: shopID);
                  // Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  // void clear() {
  //   pageNoCan = 0;
  //   pageNoLive = 0;
  //   pageNoComp = 0;
  //   _con.liveOrder = null;
  //   _con.cancelledOrder = null;
  //   _con.deliveredOrder = null;
  // }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
        duration: const Duration(milliseconds: 300), child: child);
  }
}
