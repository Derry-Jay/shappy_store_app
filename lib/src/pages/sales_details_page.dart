import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/models/order.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/controller/accounts_cum_faq_controller.dart';

class SalesDetailsPage extends StatefulWidget {
  @override
  SalesDetailsPageState createState() => SalesDetailsPageState();
}

class SalesDetailsPageState extends StateMVC<SalesDetailsPage> {
  AccountsAndFrequentlyAskedQuestionsController _con;

  final displayFormat = new DateFormat('dd MMMM yyyy'),
      apiFormat = new DateFormat('yyyy-MM-dd');

  static DateTime selectedEndDate = DateTime.now(),
      selectedStartDate = DateTime.utc(
          selectedEndDate.month == DateTime.january
              ? selectedEndDate.year - 1
              : selectedEndDate.year,
          selectedEndDate.month == DateTime.january
              ? DateTime.december
              : selectedEndDate.month - 1,
          selectedEndDate.day);
  String endDate = '', startDate = '';
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();

  SalesDetailsPageState()
      : super(AccountsAndFrequentlyAskedQuestionsController()) {
    _con = controller;
  }

  Future<void> _selectDate(BuildContext context, String flag) async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: flag == 'e' ? selectedEndDate : selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, Widget child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).primaryColor,
          ),
          dialogBackgroundColor: Colors.white,
          buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme
                  .accent //color of the text in the button "OK/CANCEL"
              ),
        ),
        child: child,
      ),
    );
    if (picked != null)
      setState(() {
        if (flag == 'e') {
          endDate = '${displayFormat.format(picked)}';
          _con.waitForSalesData(int.parse(sharedPrefs.getString("spShopID")),
              apiFormat.format(selectedStartDate), apiFormat.format(picked));
        } else if (flag == 's') {
          startDate = '${displayFormat.format(picked)}';
          _con.waitForSalesData(int.parse(sharedPrefs.getString("spShopID")),
              apiFormat.format(picked), apiFormat.format(selectedEndDate));
        }
      });
  }

  String getColor(String color) =>
      color != null && color.isNotEmpty ? color.trim().split('#')[1] : '';

  Widget _statusCard(BuildContext context, String count, String orderStatus,
      String bgColor, String txtColor) {
    return Flexible(
      child: InkWell(
        child: Card(
          elevation: 0,
          color: Color(int.parse("0xff" + getColor(bgColor))),
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height / 70,
                horizontal: MediaQuery.of(context).size.width / 50),
            child: Center(
              child: Column(children: <Widget>[
                Text(count == null ? "" : count,
                    style: TextStyle(
                        fontSize: 22,
                        color: Color(int.parse("0xff" + getColor(txtColor))),
                        fontWeight: FontWeight.bold)),
                Text(
                  orderStatus == null ? "" : orderStatus,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )
              ]),
            ),
          ),
        ),
        onTap: () => Navigator.pushNamed(context, "/Orders",
            arguments: orderStatus.endsWith("Finished")
                ? 2
                : (orderStatus.endsWith("Aborted") ? 1 : 0)),
      ),
    );
  }

  void getData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    endDate = "${displayFormat.format(selectedEndDate)}";
    startDate = "${displayFormat.format(selectedStartDate)}";
    _con.waitForSalesData(int.parse(sharedPrefs.getString("spShopID")),
        apiFormat.format(selectedStartDate), apiFormat.format(selectedEndDate));
  }

  void navigateTo(String route, RouteArgument arguments) {
    Navigator.pushNamed(context, route, arguments: arguments).then(onGoBack);
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      getData();
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text("Accounts"),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            )),
        body: Stack(
          children: [
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
            Column(
              children: [
                _con.sales == null
                    ? CircularLoadingWidget(
                        height: MediaQuery.of(context).size.height / 2,
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height / 100,
                            horizontal: MediaQuery.of(context).size.width / 50),
                        child: Card(
                            elevation: 0,
                            child: Column(children: <Widget>[
                              Container(
                                  child: Column(
                                      children: [
                                        Text(
                                          "Revenue",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        Text(
                                            _con.sales == null
                                                ? "0"
                                                : (_con.sales.revenue == null ||
                                                        _con.sales.revenue ==
                                                            "" ||
                                                        _con.sales.revenue ==
                                                            "null"
                                                    ? "0"
                                                    : _con.sales.revenue),
                                            style: TextStyle(
                                                color: Color(0xffe62136),
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            InkWell(
                                                child: Container(
                                                  child: Text(startDate,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17)),
                                                ),
                                                onTap: () =>
                                                    _selectDate(context, 's')),
                                            Text(" - ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17)),
                                            InkWell(
                                                child: Container(
                                                  child: Text(endDate,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 17)),
                                                ),
                                                onTap: () =>
                                                    _selectDate(context, 'e'))
                                          ],
                                        )
                                      ],
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 35.5)),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 21.0, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      _statusCard(
                                          context,
                                          _con.sales.pendingOrdersCount
                                              .toString(),
                                          "Order" +
                                              (_con.sales.pendingOrdersCount ==
                                                      1
                                                  ? ' '
                                                  : 's ') +
                                              "Pending",
                                          "#fff9f2",
                                          "#ff870f"),
                                      _statusCard(
                                          context,
                                          _con.sales.completedOrdersCount
                                              .toString(),
                                          "Order" +
                                              (_con.sales.completedOrdersCount ==
                                                      1
                                                  ? ' '
                                                  : 's ') +
                                              "Finished",
                                          "#f3faf2",
                                          "#52bb43"),
                                      _statusCard(
                                          context,
                                          _con.sales.cancelledOrdersCount
                                              .toString(),
                                          "Order" +
                                              (_con.sales.cancelledOrdersCount ==
                                                      1
                                                  ? ' '
                                                  : 's ') +
                                              "Cancelled",
                                          "#fef4f5",
                                          "#e62337"),
                                    ],
                                  ))
                            ], crossAxisAlignment: CrossAxisAlignment.center))),
                _con.sales == null
                    ? CircularLoadingWidget(
                        height: MediaQuery.of(context).size.height / 5
                      )
                    : (_con.sales.orders == null
                        ? CircularLoadingWidget(
                            height: MediaQuery.of(context).size.height / 5
                          )
                        : getList(_con.sales.orders, context))
              ],
            )
          ],
        ));
  }

  Widget getList(List<Order> ol, BuildContext context) => Expanded(
      child: Container(
          child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => Card(
                  child: InkWell(
                      child: Container(
                          child: Row(children: [
                            Text(
                                ol[index].date != null &&
                                        ol[index].date != "null" &&
                                        ol[index].date != ""
                                    ? displayFormat
                                        .format(DateTime.parse(ol[index].date))
                                    : "",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500)),
                            Text("#" + ol[index].orderID.toString(),
                                style: TextStyle(
                                    color: Color(0xffe62136),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                            Text("₹" + ol[index].total,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold))
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height / 70,
                              horizontal:
                                  MediaQuery.of(context).size.width / 50)),
                      onTap: () => navigateTo(
                          '/order_details',
                          RouteArgument(
                              param: ol[index], id: index.toString()))),
                  elevation: 0),
              itemCount: ol.length),
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 50)));
}
