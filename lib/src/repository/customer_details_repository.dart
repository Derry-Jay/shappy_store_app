import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shappy_store_app/src/helpers/api_service.dart';
import 'package:shappy_store_app/src/helpers/helper.dart';
import 'package:shappy_store_app/src/models/customer_details.dart';

Future<CustomerDetails> getCustomerDetails(String userID, String shopID) async {
  Uri uri = Helper.getUri('userBasedOrdersList');
  final response = await http.post(uri,
      body: {"user_ID": userID, "shop_ID": shopID},
      headers: {HttpHeaders.authorizationHeader: "Bearer " + ApiService.token});
  if (response.statusCode == 200) {
    Map<String, dynamic> jsonString =
        json.decode(response.body) as Map<String, dynamic>;
    return CustomerDetails.fromMap(jsonString);
  } else {
    throw Exception("Unable to fetch Customer Details from the REST API");
  }
}
