import 'package:flutter/material.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';

class ApprovalPausePage extends StatelessWidget {
  final RouteArgument rar;
  ApprovalPausePage(this.rar);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body:

        Column(children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("./assets/img/shappy_logo.JPG"))),
            // padding: EdgeInsets.all(200)
          ),
          Text("Your Store is Waiting For Approval",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              textAlign: TextAlign.center),
          SizedBox(height: 20),
          Text("for more details, contact +91 9841635658",
              style: TextStyle(color: Colors.black))
        ]));
  }
}
