import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shappy_store_app/src/models/otp.dart';
import 'package:shappy_store_app/src/models/user.dart';
import 'package:shappy_store_app/src/helpers/helper.dart';
import 'package:shappy_store_app/src/models/otp_success.dart';
import 'package:shappy_store_app/src/helpers/api_service.dart';

ValueNotifier<User> currentUser = new ValueNotifier(User());
Future<OTP> getOTP(String phNo) async {
  Uri uri = Helper.getUri('login');
  try {
    final response = await http.post(uri, body: {
      "shop_Mobile": phNo
    }, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + ApiService.token
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return OTP.fromMap(jsonString);
    } else {
      throw Exception('Unable to fetch OTP from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}

Future<OTPSuccess> verifyOTP(Map body) async {
  Uri uri = Helper.getUri('otpverification');
  try {
    final response = await http.post(uri, body: body, headers: {
      HttpHeaders.authorizationHeader: "Bearer " + ApiService.token
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return OTPSuccess.fromMap(jsonString);
    } else {
      throw Exception('Unable to verify OTP from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}
