import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/auth.dart';
import '../model/order.dart';

class OrderController {
  final Dio dio = Dio();
  List<Order> orderList = <Order>[];

  Future<List<Order>> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = await prefs.getString('userToken');
    dio.options.headers = {
      'X-Parse-Application-Id': 'nPkNxrgspNFHnN9jgDnsUDljfeAtEtzN9a5EM0Ae',
      'X-Parse-REST-API-Key': 'tA4JuWVyFApBOQQgdJujXbNUNsk5znqpYIfaxc6M',
      'X-Parse-Session-Token': '${token}',
    };

    final response = await dio.post('https://parseapi.back4app.com/parse/functions/get-all-orders');

    if (response.data["result"] != null) {
      orderList = (response.data["result"] as List)
          .map((data) => Order.fromJson(data))
          .toList();
    }

    return orderList;
  }
}