import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyStorePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyStorePageState();
}

class MyStorePageState extends StateMVC<MyStorePage> {
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffe62136),
        centerTitle: true,
        title: Text("My Store"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Color(0xfff3f2f2),
      body: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 40,
              decoration: BoxDecoration(
                  color: Color(0xffe62136),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)))),
          Expanded(
              child: SingleChildScrollView(
            padding: EdgeInsets.all(sqrt(
                (pow(MediaQuery.of(context).size.height, 2) +
                        pow(MediaQuery.of(context).size.width, 2)) /
                    3600)),
            child: Column(
              children: [
                Card(
                    elevation: 0,
                    child: InkWell(
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Icon(Icons.settings,
                                      color: Color(0xffed606e)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          20),
                                  Text("Settings",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500))
                                ]),
                                Icon(Icons.arrow_forward_ios_outlined, size: 10)
                              ],
                            ),
                            padding: EdgeInsets.all(sqrt((pow(
                                        MediaQuery.of(context).size.height, 2) +
                                    pow(MediaQuery.of(context).size.width, 2)) /
                                10000))),
                        onTap: () =>
                            Navigator.of(context).pushNamed("/Settings"))),
                Card(
                    elevation: 0,
                    child: InkWell(
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.notifications_none_outlined,
                                        color: Color(0xffed606e)),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                20),
                                    Text("Notifications",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                                Icon(Icons.arrow_forward_ios_outlined, size: 10)
                              ],
                            ),
                            padding: EdgeInsets.all(sqrt((pow(
                                        MediaQuery.of(context).size.height, 2) +
                                    pow(MediaQuery.of(context).size.width, 2)) /
                                10000))),
                        onTap: () =>
                            Navigator.of(context).pushNamed("/Notifications"))),
                Card(
                    elevation: 0,
                    child: InkWell(
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Icon(Icons.auto_awesome_motion,
                                      color: Color(0xffed606e)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          20),
                                  Text("Store Profile",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500))
                                ]),
                                Icon(Icons.arrow_forward_ios_outlined, size: 10)
                              ],
                            ),
                            padding: EdgeInsets.all(sqrt((pow(
                                        MediaQuery.of(context).size.height, 2) +
                                    pow(MediaQuery.of(context).size.width, 2)) /
                                10000))),
                        onTap: () =>
                            Navigator.of(context).pushNamed("/Store_profile"))),
                Card(
                    elevation: 0,
                    child: InkWell(
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Icon(Icons.help_outline_outlined,
                                      color: Color(0xffed606e)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          20),
                                  Text("Faq & Support",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500))
                                ]),
                                Icon(Icons.arrow_forward_ios_outlined, size: 10)
                              ],
                            ),
                            padding: EdgeInsets.all(sqrt((pow(
                                        MediaQuery.of(context).size.height, 2) +
                                    pow(MediaQuery.of(context).size.width, 2)) /
                                10000))),
                        onTap: () => Navigator.of(context).pushNamed("/Faq"))),
                Card(
                    elevation: 0,
                    child: InkWell(
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(children: [
                                  Icon(Icons.exit_to_app_outlined,
                                      color: Color(0xffed606e)),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          20),
                                  Text("Logout",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500))
                                ]),
                                Icon(Icons.arrow_forward_ios_outlined, size: 10)
                              ],
                            ),
                            padding: EdgeInsets.all(sqrt((pow(
                                        MediaQuery.of(context).size.height, 2) +
                                    pow(MediaQuery.of(context).size.width, 2)) /
                                10000))),
                        onTap: () async {
                          final SharedPreferences sharedPrefs =
                              await _sharePrefs;
                          // for(String key in sharedPrefs.getKeys())
                          //   if(key != "spShopID")
                          final r =
                              await sharedPrefs.setBool("logoutFlag", true);
                          // await sharedPrefs.remove("spShopID");
                          // await sharedPrefs.remove("apiToken");
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              "/Login", (Route<dynamic> route) => false);
                        }))
              ],
            ),
          ))
        ],
      ),
    );
  }
}
