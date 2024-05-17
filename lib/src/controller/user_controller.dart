import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:shappy_store_app/src/pages/approval_pause_page.dart';

import '../models/user.dart';
import '../helpers/helper.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart' as repos;
import 'package:shappy_store_app/src/models/otp.dart';
import 'package:shappy_store_app/src/models/address.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../../generated/i18n.dart';
import 'package:shappy_store_app/src/models/route_argument.dart';
import 'package:shappy_store_app/src/models/shop_category.dart';
import 'package:shappy_store_app/src/repository/shop_data_repository.dart';
// import 'package:flutter_otp/flutter_otp.dart';

class UserController extends ControllerMVC {
  // FlutterOtp omt = FlutterOtp();
  User user = new User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  OverlayEntry loader;
  OTP oneTimePassCode;
  String phoneNo = "00", imageLink;
  Address currentAddress;
  List<StoreCategory> categories = <StoreCategory>[];
  Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();
  UserController() {
    loader = Helper.overlayLoader(context);
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  // String phoneNumber = "7338965667"; //enter your 10 digit number
  // int minNumber = 10000;
  // int maxNumber = 99999;
  // String countryCode ="+91";

  void login({String ph}) async {
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(context).insert(loader);
      setState(() => phoneNo = ph);
      await repos.getOTP(ph).then((value) {
        if (value != null && value.otp != null) {
          setState(() {
            oneTimePassCode = value;
            oneTimePassCode.phNo = ph;
          });
          // omt.sendOtp(phoneNumber, value.otp.toString(),
          //     minNumber, maxNumber, countryCode);
          Helper.hideLoader(loader);
          if (oneTimePassCode != null)
            Navigator.of(context).pushNamed('/OTP',
                arguments: RouteArgument(
                    id: oneTimePassCode.oid.toString(),
                    heroTag: "restaurant_reviews",
                    param: oneTimePassCode));
        } else {
          // scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //   content: Text(S.of(context).please_check_your_connection),
          // ));
        }
      }).catchError((e) {
        loader.remove();
        Toast.show(e.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void otp(Map body) async {
    final sharedPrefs = await _sharePrefs;
    FocusScope.of(context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      final value = await repos.verifyOTP(body);
      print(value.toMap());
      if (value != null && value.success && value.status) {
        Helper.hideLoader(loader);
        await sharedPrefs.setBool("registered", value.registered);
        final r =
            await sharedPrefs.setInt("approvalStatus", value.approvedStatus);
        if (!value.registered) {
          await waitForShopCategories();
          final SharedPreferences sharedPrefs = await _sharePrefs;
          final flag = await onLocalStore(value.shopID.toString(), value.token);
          final r = await sharedPrefs.setString("phone", body['shop_Mobile']);
          if (r && flag) print(categories);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/shopNewRegistration', (Route<dynamic> route) => false,
              arguments: RouteArgument(
                  id: value.shopID.toString(), param: categories));
        } else {
          if (value.approvedStatus == 0) {
            final SharedPreferences sharedPrefs = await _sharePrefs;
            final flag =
                await onLocalStore(value.shopID.toString(), value.token);
            final r = await sharedPrefs.setInt(
                "approvalStatus", value.approvedStatus);
            print(r && flag);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ApprovalPausePage(RouteArgument(param: false))),
                (route) => false);
          } else {
            final r = await sharedPrefs.setString(
                "spShopID", value.shopID.toString());
            final s = await sharedPrefs.setString("apiToken", value.token);
            final flag = r && s;
            print(value.shopID);
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/Home', (Route<dynamic> route) => false,
                arguments:
                    RouteArgument(id: value.shopID.toString(), param: flag));
          }
        }

        // if (value.registered && value.approvedStatus == 1) {
        //   final flag = await onLocalStore(value.shopID.toString(), value.token);
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //       '/Home', (Route<dynamic> route) => false,
        //       arguments:
        //           RouteArgument(id: value.shopID.toString(), param: flag));
        // } else if (value.registered && value.approvedStatus == 0) {
        //   final SharedPreferences sharedPrefs = await _sharePrefs;
        //   final flag = await onLocalStore(value.shopID.toString(), value.token);
        //   final r =
        //       await sharedPrefs.setInt("approvalStatus", value.approvedStatus);
        //   print(r && flag);
        //   Navigator.pushAndRemoveUntil(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) =>
        //               ApprovalPausePage(RouteArgument(param: false))),
        //       (route) => false);
        // } else {
        //   await waitForShopCategories();
        //   final SharedPreferences sharedPrefs = await _sharePrefs;
        //   final flag = await onLocalStore(value.shopID.toString(), value.token);
        //   final r = await sharedPrefs.setString("phone", body['shop_Mobile']);
        //   if (r && flag) print(categories);
        //   Navigator.of(context).pushNamedAndRemoveUntil(
        //       '/shopNewRegistration', (Route<dynamic> route) => false,
        //       arguments: RouteArgument(
        //           param: {"success": value, "categories": categories}));
        // }
      } else {
        print("hi");
      }
    }
  }

  Future<bool> onLocalStore(String _shopID, String token) async {
    final SharedPreferences sharedPrefs = await _sharePrefs;
    bool flag = sharedPrefs.getString("spShopID") == null &&
        sharedPrefs.getString("apiToken") == null &&
        sharedPrefs.getString("spDeviceToken") != null;
    if (flag) {
      await sharedPrefs.setString("spShopID", _shopID);
      await sharedPrefs.setString("apiToken", token);
      return flag;
    } else {
      if (sharedPrefs.getString("spShopID") != null)
        await sharedPrefs.setString("apiToken", token);
      else if (sharedPrefs.getString("apiToken") != null)
        await sharedPrefs.setString("spShopID", _shopID);
      else {
        await sharedPrefs.setString("spShopID", _shopID);
        await sharedPrefs.setString("apiToken", token);
      }
      return false;
    }
  }

  Future<void> waitUntilRegister(Map<String, dynamic> body) async {
    await updateNewShopData(body).then((value) async {
      if (value != null && value["status"] && value["success"]) {
        final sharedPrefs = await _sharePrefs;
        final r = await sharedPrefs.setBool("registered", true);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ApprovalPausePage(RouteArgument(param: false))),
            (route) => false);
        // Toast.show(value["message"], context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else
        Toast.show("Error", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e.toString(), context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM));
  }

  // void updateStoreDetail(Map<String, dynamic> body) async {
  //   await repos.updateShopData(body)
  //       .then((value) {
  //     if (value != null && value["status"] && value["success"]) {
  //       waitForStoreData(shopID: body["shop_ID"]);
  //       Navigator.of(context).pop();
  //       Toast.show(value["message"], context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //     } else
  //       Toast.show("Error", context,
  //           duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  //   })
  //       .catchError((e) => Toast.show(e, context,
  //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM))
  //       .whenComplete(() => Toast.show("Done", context,
  //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM));
  // }

  void waitUntilNewShopImageUpload(PickedFile _image) async {
    await uploadShopImage(_image).then((value) async {
      if (value != null && value.success && value.status) {
        setState(() => imageLink = value.imageUrl);
      }
    });
  }

  Future<void> waitForShopCategories() async {
    await getShopCategories().then((value) {
      if (value != null && value.length != 0)
        setState(() => categories = value);
      else
        Toast.show("No Shop Categories", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }).catchError((e) => Toast.show(e.toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM))
        // .whenComplete(() => Toast.show("Done", context,
        //     duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM))
        ;
  }
}
