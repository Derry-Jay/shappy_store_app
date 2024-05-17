import 'add_store_detail_page.dart';
import 'add_store_location_page.dart';
import 'package:flutter/material.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';

class StoreDataEditTabsPage extends StatelessWidget {
  final RouteArgument rar;
  StoreDataEditTabsPage(this.rar);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            title: Text('Edit Store Profile'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            elevation: 0),
        body: Column(children: [
          Container(
              decoration: BoxDecoration(
                  color: Color(0xffe62136),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20))),
              padding: EdgeInsets.all(10)),
          Expanded(
              child: SingleChildScrollView(
            child: Container(
              child: DefaultTabController(
                length: 2,
                initialIndex: rar.id == null ? 0 : int.parse(rar.id),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      padding: EdgeInsets.only(top: 20),
                      child: TabBar(
                        physics: NeverScrollableScrollPhysics(),
                        tabs: [
                          Tab(
                            text: 'Store Details',
                          ),
                          Tab(text: "Store Location"),
                        ],
                        labelColor: Colors.black,
                        indicatorColor: Color(0xffe62136),
                        labelStyle: TextStyle(
                            fontSize: 23, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 600,
                      child: TabBarView(
                        children: [
                          StoreDetailsPage(rar),
                          StoreLocationPage(rar),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))
        ]));
  }
}
