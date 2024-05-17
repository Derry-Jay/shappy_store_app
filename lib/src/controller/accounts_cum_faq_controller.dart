import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shappy_store_app/generated/l10n.dart';
import 'package:shappy_store_app/src/models/faq.dart';
import 'package:shappy_store_app/src/models/sales.dart';
import 'package:shappy_store_app/src/repository/accounts_cum_faq_repository.dart'
    as repos;
import 'package:toast/toast.dart';

class AccountsAndFrequentlyAskedQuestionsController extends ControllerMVC {
  List<FrequentlyAskedQuestions> faqs;
  Sales sales;
  GlobalKey<ScaffoldState> scaffoldKey;
  AccountsAndFrequentlyAskedQuestionsController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }
  void waitForFaq({int faqType}) async {
    await repos.getFAQ(faqType).then((value) {
      if (value != null && value.length != 0) {
        setState(() => faqs = value);
      } else {
        scaffoldKey?.currentState?.showSnackBar(SnackBar(
          content: Text(S.of(context).verify_your_internet_connection),
        ));
      }
    }).catchError((e) {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    });
  }

  void waitForSalesData(int shopID, String startDate, String endDate) async {
    final value = await repos.getSalesData(shopID, startDate, endDate);
    if (value != null)
      setState(() => sales = value);
    else
      Toast.show("Error in Fetching Data", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }
}
