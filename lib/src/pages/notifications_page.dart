import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f2f2),
      appBar: AppBar(
        title: Text("Notification"),
        centerTitle: true,
        backgroundColor: Color(0xffe62136),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              decoration: BoxDecoration(
                  color: Color(0xffe62136),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              padding: EdgeInsets.all(10)),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    "27 July 2020",
                    style: TextStyle(color: Color(0xffe62136)),
                  ),
                  padding: EdgeInsets.all(15),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Card(
                    elevation: 0,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      child: Text("#123456789 Order Recieved",
                          style: TextStyle(
                              fontSize: 16, color: Color(0xffe62136))),
                    ),
                  ),
                ),
                Container(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text("#123456789 Order Recieved",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xffe62136))),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15)),
                Container(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text("#123456789 Order Recieved",
                            style: TextStyle(
                                fontSize: 16, color: Color(0xffe62136))),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15)),
                Container(
                  child: Text(
                    "27 July 2020",
                    style: TextStyle(color: Colors.black),
                  ),
                  padding: EdgeInsets.all(15),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Card(
                    elevation: 0,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                  ),
                ),
                Container(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15)),
                Container(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15)),
                Container(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15)),
                Container(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15)),
                Container(
                    child: Card(
                      elevation: 0,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Text(
                            "Lorem Ipsum is simply dummy text of the printing and typesetting industry.Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black)),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 15, right: 15))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
