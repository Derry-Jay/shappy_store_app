import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shappy_store_app/src/controller/user_controller.dart';
import 'package:toast/toast.dart';

class LogoPage extends StatefulWidget {
  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends StateMVC<LogoPage> {
  int status;
  String shopID;
  bool registered, logoutFlag;
  UserController _con;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  _LogoPageState() : super(UserController()) {
    _con = controller;
  }

  void setData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    await _con.waitForShopCategories();
    shopID = sharedPrefs.getString("spShopID");
    status = sharedPrefs.containsKey("approvalStatus")
        ? sharedPrefs.getInt("approvalStatus")
        : 0;
    registered = sharedPrefs.containsKey("registered")
        ? sharedPrefs.getBool("registered")
        : false;
    logoutFlag = sharedPrefs.containsKey("logoutFlag")
        ? sharedPrefs.getBool("logoutFlag")
        : false;
    print(shopID);
    print(status);
    print(registered);
  }

  @override
  void initState() {
    setData();
    super.initState();
    Timer(Duration(seconds: 3), () async {
      print("------------------");
      print(status);
      print(registered);
      print("------------------");
      if (shopID != null && logoutFlag && registered && status == 1)
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/Login", (route) => false);
      else {
        if (shopID == null) {
          Navigator.of(context).pushNamed('/Splash');
        } else {
          if (!registered) {
            Navigator.of(context).pushNamed('/shopNewRegistration',
                arguments: RouteArgument(id: shopID, param: _con.categories));
          } else {
            // Toast.show(status.toString(), context, gravity: Toast.TOP);
            if (status == 0)
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/Login", (route) => false);
            else
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/Home', (Route<dynamic> route) => false,
                  arguments: RouteArgument(id: shopID, param: false));
          }
        }
      }
    });
  }
  // shopID == null
  // ? Navigator.of(context).pushNamed('/Splash')
  //     : !registered
  // ? Navigator.of(context).pushNamedAndRemoveUntil(
  // '/Login', (Route<dynamic> route) => false,
  // arguments: RouteArgument(
  // id: shopID, param: shopID == null, heroTag: "0"))
  //     : (status == 0 && registered
  // ? Navigator.of(context).pushNamedAndRemoveUntil(
  // "/waitForApproval", (route) => false)
  //     : print("hi")))

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/img/Group 9443.png',
            width: MediaQuery.of(context).size.width,
          ),
        ],
      ),
    );
  }
}
