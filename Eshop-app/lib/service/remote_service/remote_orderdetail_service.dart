


import 'dart:convert';
import 'package:eshop/const.dart';
import 'package:http/http.dart' as http;
import 'package:eshop/model/order_detail.dart';

Future<List<OrderDetail>> getOrderDetails(int orderId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/orderDetail/order/$orderId'),
    headers: {"Accept": "application/json", "Content-Type": "application/json;charset=UTF-8"},
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
    return data.map((json) => OrderDetail.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load order details');
  }
}
