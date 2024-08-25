import 'dart:convert';

import 'package:eshop/model/userInfo.dart';


class Cart {
  final int cartId;
  final double amount;
  late final String address;
  late final String phone;
  final UserIf user;

  Cart({
    required this.cartId,
    required this.amount,
    required this.address,
    required this.phone,
    required this.user,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cartId'],
      amount: json['amount'].toDouble(),
      address: json['address'],
      phone: json['phone'],
      user: UserIf.fromJson(json['user']),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'cartId': cartId,
      'amount': amount,
      'address': address,
      'phone': phone,
      'user': user.toJson(),
    };
  }
}
