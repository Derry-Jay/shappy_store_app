import 'dart:math';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/models/order.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/models/ordered_product.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/controller/home_and_order_controller.dart';

class OrderDetailsPage extends StatefulWidget {
  final RouteArgument rar;
  OrderDetailsPage(this.rar);
  @override
  State<StatefulWidget> createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends StateMVC<OrderDetailsPage> {
  int index;
  Order order;
  HomeAndOrderController _con;
  TextEditingController crc = new TextEditingController();
  OrderDetailsPageState() : super(HomeAndOrderController()) {
    _con = controller;
  }

  @override
  void initState() {
    index = int.parse(widget.rar.id);
    order = widget.rar.param;
    _con.waitForOrderDetails(order.orderID.toString());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Details"),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Color(0xffe62136),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
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
            _con.orderDetails == null
                ? CircularLoadingWidget(
                    height: 500,
                  )
                : Container(
                    child: Column(children: [
                      _con.orderDetails.customer == null
                          ? CircularLoadingWidget(
                              height: 100,
                            )
                          : Container(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 50,
                                  left: MediaQuery.of(context).size.width / 80),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          '#' +
                                              _con.orderDetails.customer.orderID
                                                  .toString(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                        Container(
                                            child: Visibility(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height /
                                                              160,
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              25),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffe62136),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      20.0),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      20.0))),
                                                  child: Text(
                                                    _con.orderDetails.customer
                                                                .paymentType ==
                                                            0
                                                        ? 'Cash On Delivery'
                                                        : (_con
                                                                    .orderDetails
                                                                    .customer
                                                                    .paymentType ==
                                                                1
                                                            ? 'Store Pickup'
                                                            : ''),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12),
                                                  ),
                                                ),
                                                visible: true),
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2,
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100,
                                                bottom: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    100))
                                      ],
                                    ),
                                    Text(
                                      _con.orderDetails.customer.userName,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    Text(_con.orderDetails.customer.area,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15))
                                  ]),
                            ),
                      new Divider(
                        color: Colors.black26,
                      ),
                      Visibility(
                          child: Container(
                              child: Column(children: [
                                Text("Cancel Reason",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black26)),
                                Text(
                                    _con.orderDetails.customer.cancelReason !=
                                            null
                                        ? _con
                                            .orderDetails.customer.cancelReason
                                        : (order.cancelReason != null
                                            ? order.cancelReason
                                            : ""),
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black))
                              ]),
                              padding: EdgeInsets.only(left: 10)),
                          visible: _con.orderDetails.customer.orderStatus == 6),
                      new Divider(
                        color: Colors.black26,
                      ),
                      _con.orderDetails.products == null
                          ? CircularLoadingWidget(
                              height: MediaQuery.of(context).size.height / 2,
                            )
                          : Container(
                              padding: EdgeInsets.all(sqrt(
                                  (pow(MediaQuery.of(context).size.height, 2) +
                                          pow(MediaQuery.of(context).size.width,
                                              2)) /
                                      22500)),
                              child: buildList(_con.orderDetails.products),
                              height: ((_con.orderDetails.products.length *
                                          MediaQuery.of(context).size.height) /
                                      20)
                                  .toDouble(),
                            ),
                      Container(
                        padding: EdgeInsets.all(sqrt(
                            (pow(MediaQuery.of(context).size.height, 2) +
                                    pow(MediaQuery.of(context).size.width, 2)) /
                                10000)),
                        child: Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "Total",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 32,
                              ),
                              Text(
                                _con.orderDetails.customer.total.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 17),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          Visibility(
                            child: ButtonTheme(
                                child: RaisedButton(
                                  onPressed: () =>
                                      _showDialog(_con.orderDetails.customer),
                                  child: Text("Cancel"),
                                  color: Color(0xffe62136),
                                  textColor: Colors.white,
                                ),
                                minWidth: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height / 15),
                            visible:
                                _con.orderDetails.customer.orderStatus != 6 &&
                                    _con.orderDetails.customer.orderStatus != 5,
                          )
                        ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                      )
                    ], crossAxisAlignment: CrossAxisAlignment.start),
                    padding: EdgeInsets.all(sqrt(
                        (pow(MediaQuery.of(context).size.height, 2) +
                                pow(MediaQuery.of(context).size.width, 2)) /
                            10000)))
          ],
        ),
        backgroundColor: Color(0xfff3f2f2));
  }

  Widget buildList(List<OrderedProduct> op) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
        itemCount: op.length,
        itemBuilder: (BuildContext context, int index) {
          if (!op.contains(null) && op != null && op != []) {
            return Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 80),
                child: Row(children: <Widget>[
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      child: Text(
                          op[index].productName != null
                              ? op[index].productName
                              : "NULL",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                              color: Colors.black)),
                    ),
                  ),
                  Flexible(
                    // padding: EdgeInsets.all(10),
                    fit: FlexFit.tight,
                    flex: 1,
                    child: Text(
                      op[index].cartCount != null
                          ? op[index].cartCount.toString()
                          : "NULL",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                          color: Colors.black),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Flexible(
                    // padding: EdgeInsets.all(10),
                    fit: FlexFit.tight,
                    flex: 2,
                    child: Container(
                        child: Text(
                            (op[index].cartCount != null
                                ? (op[index].price * op[index].cartCount)
                                    .toString()
                                : "Null"),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17)),
                        alignment: Alignment.centerRight),
                  )
                ], mainAxisAlignment: MainAxisAlignment.spaceBetween));
          } else {
            return CircularLoadingWidget(
              height: 100,
            );
          }
        });
  }

  void _showDialog(Order item) async {
    await showDialog<String>(
      context: context,
      child: _SystemPadding(
        child: new AlertDialog(
          contentPadding: EdgeInsets.all(16.0),
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
                onPressed: () {
                  if (crc.text != null && crc.text != "") {
                    Navigator.pop(context);
                    _con.cancelOrder(
                        cancelReason: crc.text,
                        orderID: item.orderID,
                        index: index);
                    setState(() => item.cancelBy = "0");
                  } else
                    Toast.show("Please Provide Cancel Reason", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }),
          ],
        ),
      ),
    );
  }
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
