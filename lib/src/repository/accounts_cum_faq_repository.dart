import 'dart:io';
import 'dart:convert';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shappy_store_app/src/helpers/api_service.dart';
import 'package:shappy_store_app/src/models/faq.dart';
import 'package:shappy_store_app/src/models/faq_base.dart';
import 'package:shappy_store_app/src/models/sales.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<SharedPreferences> _sharePrefs = SharedPreferences.getInstance();

Future<List<FrequentlyAskedQuestions>> getFAQ(int faqType) async {
  final response = await http.post(
      ApiService.baseUrl + (faqType == 1 ? 'userFAQ' : 'shopFAQ'),
      headers: {HttpHeaders.authorizationHeader: "Bearer " + ApiService.token},
      body: {"Faq_type": faqType.toString()});
  try {
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return FrequentlyAskedQuestionsBase.fromMap(jsonString).faqs;
    } else {
      throw Exception("Unable to get FAQ from the REST API");
    }
  } catch (e) {
    print(e);
    throw (e);
  }
}

Future<Sales> getSalesData(int shopID, String startDate, String endDate) async {
  final client = new http.Client();
  final SharedPreferences sharedPrefs = await _sharePrefs;
  final String url =
      '${GlobalConfiguration().getString('base_url')}accountsPage';
  try {
    final response = await client.post(url, headers: {
      HttpHeaders.authorizationHeader:
          "Bearer " + sharedPrefs.getString("apiToken")
    }, body: {
      "shop_ID": shopID.toString(),
      "from": startDate,
      "to": endDate
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonString =
          json.decode(response.body) as Map<String, dynamic>;
      return Sales.fromMap(jsonString);
    } else {
      throw Exception('Unable to fetch customers from the REST API');
    }
  } catch (e) {
    print(e);
    throw e;
  }
}
