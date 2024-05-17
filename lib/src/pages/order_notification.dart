import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/models/ordered_product.dart';
import 'package:shappy_store_app/src/elements/CircularLoadingWidget.dart';
import 'package:shappy_store_app/src/controller/home_and_order_controller.dart';
class OrderNotification extends StatefulWidget {
  final String orderID;
  OrderNotification(this.orderID);
  @override
  State<StatefulWidget> createState() => OrderNotificationState();
}

class OrderNotificationState extends StateMVC<OrderNotification>{
  HomeAndOrderController _con;
  TextEditingController crc = new TextEditingController();
  OrderNotificationState() : super(HomeAndOrderController()){
    _con = controller;
  }

  void initState(){
    _con.waitForOrderDetails(widget.orderID);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe62136),
      body: Container(
        child: _con.orderDetails == null ? CircularLoadingWidget(height: 100,) : Column(
          children: [
            Column(
              children: <Widget>[
                Container(
                  // padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 100,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  // flex: 2,
                  // fit: FlexFit.tight,
                  child: Text(
                    "Order Recieved",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Text(_con.orderDetails.customer.orderID != null ?
                  _con.orderDetails.customer.orderID.toString() : "",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                    maxLines: 2,
                  ),
                ),
                Container(
                  child: Text(_con.orderDetails.customer.userName != null ? _con.orderDetails.customer.userName : "" + _con.orderDetails.customer.area != null ? _con.orderDetails.customer.area : "",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                )
              ],
            ),
            constructList(_con.orderDetails.products),
            Container(
              child: Text(
                _con.orderDetails.customer.total != null ? _con.orderDetails.customer.total.toString() : "",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(5.0)),
                  onPressed: () {
                    print("Hi");
                  },
                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Text(
                    "Approve",
                    style: TextStyle(fontSize: 20),
                  ),
                  color: Colors.white,
                  textColor: Color(0xffe62136),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
              child: ButtonTheme(
                minWidth: double.infinity,
                height: 50,
                child: FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext bc) {
                          return Container(
                            height: 250,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              // color: Colors.redAccent[400],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Cancel Reason",
                                  style: TextStyle(
                                      color: Color(0xffe62136),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(controller: crc,onSubmitted: (value)=>crc.text = value,textInputAction: TextInputAction.next,),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.all(20.0),
                                  child: ButtonTheme(
                                    minWidth: double.infinity,
                                    height: 45,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Map body = {"order_status":"6","order_ID":"284","cancel_reason":crc.text};
                                        print(crc.text);
                                        setState(() {
                                          // putCancelReason(body);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      color: Color(0xffe62136),
                                      textColor: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: Text("Cancel"),
                  color: Color(0xffe62136),
                  textColor: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget constructList(List<OrderedProduct> oil) {
    return Expanded(
      flex: 9,
      // padding: EdgeInsets.all(10),
      child: ListView.builder(
          itemCount: oil.length,
          itemBuilder: (BuildContext context, int index) {
            return Expanded(
                child: Row(children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        child: Text(
                          oil[index].productName != null ? oil[index].productName : "",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )),
                  Flexible(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.all(10),
                        child: Text(oil[index].cartCount != null ? oil[index].cartCount.toString() : "",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ))
                ]));
          }),
    );
  }
}