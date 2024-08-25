import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eshop/const.dart';
import 'package:eshop/model/cart.dart';

Future<Cart> updateCart(String email, Cart cart) async {
  final String apiUrl = '$baseUrl/api/cart/user/$email';

  try {
    // final jsonUtf8 = jsonEncode(cart.toJson()).codeUnits;
    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(cart.toJson()),

    );
    print(response.body);
    if (response.statusCode == 200) {
      // Giải mã chuỗi địa chỉ từ UTF-8 sang Unicode
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return Cart.fromJson(jsonData);
    } else {
      throw Exception('Failed to update cart: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to update cart: $e');
  }
}
