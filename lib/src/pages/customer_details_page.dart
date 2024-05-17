import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shappy_store_app/src/models/order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/models/customer_details.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/controller/customer_details_controller.dart';

class CustomerDetailsPage extends StatefulWidget {
  final String userID;
  CustomerDetailsPage(this.userID);
  @override
  State<StatefulWidget> createState() => CustomerDetailsPageState(this.userID);
}

class CustomerDetailsPageState extends StateMVC<CustomerDetailsPage> {
  String userID, shopID, orderDate;
  CustomerDetailsController _con;
  static var myFormat = new DateFormat('dd MMMM yyyy');
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  CustomerDetailsPageState(this.userID) : super(CustomerDetailsController()) {
    _con = controller;
  }
  void pickSessionData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    shopID = sharedPrefs.getString("spShopID");
    _con.waitForCustomerDetails(userID: userID, shopID: shopID);
  }

  void initState() {
    pickSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CustomerDetails cusDet = _con.details;
    if(_con.details != null)
      print(_con.details.orders);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () => Navigator.pop(context)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Color(0xffe62136),
          title: Text('Orders'),
          // actions: <Widget>[
          //   IconButton(
          //       icon: Icon(Icons.search),
          //       onPressed: () {
          //         print('search icon');
          //       }),
          // ]
        ),
        body: cusDet == null
            ? CircularLoadingWidget(height: MediaQuery.of(context).size.height / 5)
            : Column(children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 50,
                      horizontal: MediaQuery.of(context).size.width / 40),
                  decoration: BoxDecoration(
                      color: Color(0xffe62136),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            // fit: FlexFit.tight,
                            flex: 7,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(cusDet.customer.userName == null ? 'Shappy User': cusDet.customer.userName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17)),
                                  Text(cusDet.customer.phNo,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17)),
                                  // Text(cusDet.customer.area,
                                  //     style: TextStyle(
                                  //         color: Colors.white, fontSize: 18))
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 50),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: FlatButton(
                                    onPressed: () =>
                                        launch("tel://" + cusDet.customer.phNo),
                                    child: Icon(
                                      Icons.add_ic_call,
                                      color: Colors.white,
                                    )),
                              ))
                        ],
                      ),
                      Container(
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            cusDet.customer.orderCount
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 23.5),
                                            textAlign: TextAlign.center),
                                        Text("Orders",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17),
                                            textAlign: TextAlign.center)
                                      ],
                                    ),
                                    padding: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.width /
                                                50)),
                              ),
                              VerticalDivider(
                                  color: Colors.white,
                                  thickness:
                                      MediaQuery.of(context).size.width / 100,
                                  width:
                                      MediaQuery.of(context).size.width / 125),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    Text( "₹" + cusDet.customer.aov.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23.5)),
                                    Text("AOV",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17))
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.white,
                                thickness:
                                    MediaQuery.of(context).size.width / 100,
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("₹" + cusDet.customer.tov.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23.5)),
                                    Text("Total Value",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: buildList(cusDet.orders),
                )
              ]),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {},
        //   child: Icon(Icons.filter_alt_outlined),
        //   tooltip: 'Filter',
        //   backgroundColor: Colors.redAccent[400],
        // ),
        backgroundColor: Color(0xfff3f2f2));
  }

  Widget buildList(List<Order> ol) {
    if (ol == null || ol.contains(null) || ol.isEmpty) {
      return CircularLoadingWidget(height: 500);
    } else {
      return ListView.builder(
          itemCount: ol.length,
          itemBuilder: (BuildContext context, int index) {
            orderDate = ol[index].date == null || ol[index].date == "null"
                ? ""
                : myFormat.format(DateTime.parse(ol[index].date));
            return Container(
              child: Card(
                elevation: 0,
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 300,
                            horizontal: MediaQuery.of(context).size.width / 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("#" + ol[index].orderID.toString(),
                                style: TextStyle(
                                    fontSize: 17, color: Color(0xffe62136))),
                            Text(
                              "₹" + ol[index].total,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        )),
                    Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              orderDate,
                              style:
                                  TextStyle(fontSize: 17, color: Colors.black),
                            ),
                            FlatButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed('/order_details',
                                        arguments: RouteArgument(
                                            param: ol[index],
                                            id: index.toString())),
                                child: Text(
                                  'Details \u2192',
                                  style: TextStyle(
                                      color: Color(0xffe62136), fontSize: 18),
                                  textAlign: TextAlign.right,
                                ))
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 300,
                            horizontal:
                                MediaQuery.of(context).size.width / 40)),
                    Container(
                        child: Row(children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width / 40),
                            decoration: BoxDecoration(
                                color: Color(0xffe62136),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0))),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      MediaQuery.of(context).size.height / 125,
                                  horizontal:
                                      MediaQuery.of(context).size.width / 125),
                              child: Text(
                                ol[index].paymentType == 0
                                    ? 'Cash On Delivery'
                                    : 'Store Pickup',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 64)
                        ]),
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width / 50),
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 300,
                            horizontal: MediaQuery.of(context).size.width / 40))
                  ],mainAxisAlignment: MainAxisAlignment.spaceAround
                ),
              ),
            );
          });
    }
  }
}
