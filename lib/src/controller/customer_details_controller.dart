import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/generated/l10n.dart';
import 'package:shappy_store_app/src/models/customer_details.dart';
import 'package:shappy_store_app/src/repository/customer_details_repository.dart' as repos;
class CustomerDetailsController extends ControllerMVC{
  CustomerDetails details;
  GlobalKey<ScaffoldState> scaffoldKey;
  CustomerDetailsController(){
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  void waitForCustomerDetails({String userID,String shopID}) async {
    await repos.getCustomerDetails(userID,shopID).then((value) {
      if(value!=null){
        setState(() => details = value);
      } else {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).verify_your_internet_connection),
        ));
      }
    }).catchError((e){
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    });
  }
}