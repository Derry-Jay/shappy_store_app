import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/app_config.dart' as config;
import 'package:shappy_store_app/src/controller/user_controller.dart';
import 'package:shappy_store_app/src/elements/BlockButtonWidget.dart';
// import 'package:flutter_otp/flutter_otp.dart';
// import 'package:flutter_sms/flutter_sms.dart';
// FlutterOtp otp = FlutterOtp();

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends StateMVC<LoginScreen> {
  UserController _con;
  TextEditingController phc = new TextEditingController();
  LoginScreenState() : super(UserController()) {
    _con = controller;
  }
  // String phoneNumber = "7904938067"; //enter your 10 digit number
  // int minNumber = 10000;
  // int maxNumber = 99999;
  // String countryCode ="+91";


  @override
  void initState() {
    super.initState();
  }


 //  void sendOtp(String phoneNumber, [String messageText]) {
 // print(phc.text);
 //  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
//sign up to get started and experience great shopping deals
          Positioned(
            top: config.App(context).appHeight(37) - 120,
            child: Container(
              width: config.App(context).appWidth(84),
              height: config.App(context).appHeight(37),
              child: Text(
                "Welcome",
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .merge(TextStyle(color: Theme.of(context).accentColor)),
              ),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(37) - 80,
            child: Container(
              width: config.App(context).appWidth(84),
              height: config.App(context).appHeight(37),
              child: Text(
                "Sign up to get started and experience great shopping deals",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .merge(TextStyle(color: Colors.black)),
              ),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(37) - 10,
            child: Container(
              width: config.App(context).appWidth(88),
              child: Form(
                key: _con.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      maxLength: 10,
                      maxLengthEnforced: true,
                      controller: phc,
                      onFieldSubmitted: (value) => phc.text = value,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      validator: (value) => value.length != 10
                          ? "Enter a valid mobile number"
                          : null,
                      decoration: InputDecoration(
                        labelText: "Mobile No",
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12),
                        hintText: '978.....',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.3)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 30),
                    BlockButtonWidget(
                      text: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () => {
                        _con.login(ph: phc.text)
                      },
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height / 50),
                    // FlatButton(
                    //   onPressed: () =>phc.text = "",
                    //   shape: StadiumBorder(),
                    //   textColor: Theme.of(context).hintColor,
                    //   child: Text("Clear"),
                    //   padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
