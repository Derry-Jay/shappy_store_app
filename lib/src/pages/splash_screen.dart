import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../controller/splash_screen_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  String shopID, butText = "";
  SplashScreenController _con;
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  void pickSessionData() async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    shopID = sharedPrefs.getString("spShopID");
  }

  @override
  void initState() {
    pickSessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    butText = shopID == null ? 'GET STARTED' : 'WELCOME BACK';
    return WillPopScope(
        child: Scaffold(
          key: _con.scaffoldKey,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(28.0),
                      bottomLeft: Radius.circular(28.0),
                    ),
                    color: const Color(0xffe62337),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 2),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                ),
                Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 8,
                        top: MediaQuery.of(context).size.height / 1.41,
                        right: MediaQuery.of(context).size.width / 8),
                    child: Image.asset(
                      'assets/img/shappy_we.JPG',
                      fit: BoxFit.fitWidth,
                    )),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.25,
                  margin: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height / 1000,
                      horizontal: MediaQuery.of(context).size.width / 400),
                  child: Image.asset(
                    'assets/img/splash.png',
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 20,
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 220,
                        top: MediaQuery.of(context).size.height / 1.06,
                        right: MediaQuery.of(context).size.width / 220),
                    child: RaisedButton(
                      onPressed: () {
                        try {
                          shopID == null
                              ? Navigator.of(context).pushNamed('/Login')
                              : Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/Home', (Route<dynamic> route) => false,
                                  arguments: RouteArgument(
                                      id: shopID,
                                      param: shopID == null)); //Home
                        } catch (e) {
                          Toast.show(e, context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.BOTTOM);
                          SystemNavigator.pop();
                        }
                      },
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF000000),
                        ),
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(butText, style: TextStyle(fontSize: 12)),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 50),
                              Icon(
                                Icons.arrow_forward,
                                size: 20,
                                color: Color(0xFFFFFFFF),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () {
          SystemNavigator.pop();
          SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
          return Future.value(false);
        });
  }
}
