import 'package:toast/toast.dart';
import './customer_details_page.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shappy_store_app/src/models/customer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/controller/shop_data_controller.dart';

class CustomersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CustomersPageState();
}

class CustomersPageState extends StateMVC<CustomersPage> {
  int page;
  String shopID;
  ScrollController cont;
  StoreDataController _con;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  CustomersPageState() : super(StoreDataController()) {
    _con = controller;
  }
  void pickSessionData() async {
    page = 0;
    final SharedPreferences sharedPrefs = await _sharePrefs;
    cont = new ScrollController()..addListener(scrollListener);
    shopID = sharedPrefs.getString("spShopID");
    _con.listenForCustomers(shopID: shopID, page: page.toString());
  }

  void initState() {
    pickSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("My Customers"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // actions: <Widget>[
          //   IconButton(
          //       icon: Icon(Icons.search),
          //       onPressed: () {
          //         print('search icon');
          //       })
          // ]
        ),
        body: Column(children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
                ),
                color: Color(0xffe62136)),
            height: MediaQuery.of(context).size.height / 30,
          ),
          constructCustomerList(_con.customers)
        ]),
        backgroundColor: Color(0xfff3f2f2));
  }

  Widget constructCustomerList(List<Customer> customerList) => Expanded(
      child: customerList == null
          ? CircularLoadingWidget(
              height: MediaQuery.of(context).size.height / 1.28)
          : (customerList.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/img/empty_customers.png"))),
                  height: MediaQuery.of(context).size.height / 20)
              : ListView.builder(
                  controller: cont,
                  itemCount: customerList.length,
                  itemBuilder: (BuildContext context, int index) => index ==
                          customerList.length
                      ? (customerList.length < 10
                          ? Container(height: 0, width: 0)
                          : CircularLoadingWidget(height: 30))
                      : Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 40,
                              vertical:
                                  MediaQuery.of(context).size.height / 250),
                          child: InkWell(
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width / 80,
                                    vertical:
                                        MediaQuery.of(context).size.height /
                                            50),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            35),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      customerList[index]
                                                                  .userName ==
                                                              null
                                                          ? 'Shappy User'
                                                          : customerList[index]
                                                              .userName,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                        customerList[index]
                                                            .phNo,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    // Text(customerList[index].area,
                                                    //     style: TextStyle(
                                                    //         color: Colors.black,
                                                    //         fontSize: 16,
                                                    //         fontWeight: FontWeight.w500))
                                                  ],
                                                ))),
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      customerList[index]
                                                          .orderCount
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 24),
                                                    ),
                                                    Text("Orders",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 17))
                                                  ]),
                                            )),
                                        Expanded(
                                            flex: 2,
                                            // fit: FlexFit.tight,
                                            child: Container(
                                              child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      customerList[index]
                                                          .aov
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 25),
                                                    ),
                                                    Text("AOV",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 17))
                                                  ]),
                                            ))
                                      ],
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              60,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80),
                                        Expanded(
                                          child: ButtonTheme(
                                              child: OutlineButton(
                                                  disabledBorderColor: Colors
                                                      .black26,
                                                  onPressed: () => launch(
                                                      "tel://" +
                                                          customerList[index]
                                                              .phNo),
                                                  child: Text("Call",
                                                      style: TextStyle(
                                                          fontSize: 11)),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  10.0)))),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80),
                                        Expanded(
                                          child: ButtonTheme(
                                              child: OutlineButton(
                                                  disabledBorderColor:
                                                      Colors.black26,
                                                  onPressed: () => launch(
                                                      "sms:" +
                                                          customerList[index]
                                                              .phNo),
                                                  child: Text("SMS",
                                                      style: TextStyle(
                                                          fontSize: 11)),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  10.0)))),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80),
                                        Expanded(
                                          child: ButtonTheme(
                                              child: OutlineButton(
                                                  disabledBorderColor:
                                                      Colors.black26,
                                                  onPressed: () async {
                                                    await canLaunch(
                                                            "whatsapp://send?phone=" +
                                                                customerList[
                                                                        index]
                                                                    .phNo)
                                                        .then((value) {
                                                      if (value) {
                                                        launch(
                                                            "whatsapp://send?phone=+91 " +
                                                                customerList[
                                                                        index]
                                                                    .phNo);
                                                      } else {
                                                        print(
                                                            "WhatsApp is not installed");
                                                        Toast.show(
                                                            "WhatsApp is not installed",
                                                            context,
                                                            duration: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      }
                                                    });
                                                  },
                                                  child: Text("WhatsApp",
                                                      style: TextStyle(
                                                          fontSize: 8)),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  10.0)))),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80),
                                        Expanded(
                                          child: ButtonTheme(
                                              child: OutlineButton(
                                                  disabledBorderColor:
                                                      Colors.black26,
                                                  onPressed: () {},
                                                  child: Text(
                                                    "Coupon",
                                                    style:
                                                        TextStyle(fontSize: 11),
                                                  ),
                                                  shape:
                                                      new RoundedRectangleBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  10.0)))),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                80)
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerDetailsPage(
                                        customerList[index]
                                            .userID
                                            .toString()))),
                          ),
                        ))));

  void scrollListener() {
    if (cont.position.pixels == cont.position.maxScrollExtent)
      setState(() {
        page += 1;
        _con.listenForCustomers(shopID: shopID, page: page.toString());
      });
  }
}
