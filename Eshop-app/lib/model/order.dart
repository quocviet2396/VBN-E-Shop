import 'package:eshop/model/user.dart';
import 'package:eshop/model/userInfo.dart';

class Order {
  final int ordersId;
  final DateTime orderDate;
  final double amount;
  final String address;
  final String phone;
  final int status;


  Order({
    required this.ordersId,
    required this.orderDate,
    required this.amount,
    required this.address,
    required this.phone,
    required this.status,

  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      ordersId: json['ordersId'] as int,
      orderDate: DateTime.parse(json['orderDate'] as String),
      amount: (json['amount'] as num).toDouble(),
      address: json['address'] as String,
      phone: json['phone'] as String,
      status: json['status'] as int,

    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ordersId': ordersId,
      'orderDate': orderDate.toIso8601String(),
      'amount': amount,
      'address': address.toString(),
      'phone': phone,
      'status': status,

    };
  }
}