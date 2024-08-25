import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eshop/model/cart.dart';
import 'package:eshop/model/cart_detail.dart';
import '../../const.dart';

Future<List<CartDetail>> fetchCartDetailsById(int id) async {
  final response = await http.get(Uri.parse('$baseUrl/api/cartDetail/cart/$id'));

  if (response.statusCode == 200) {
    // Nếu request thành công, giải mã JSON và trả về dữ liệu
    Iterable jsonResponse = json.decode(utf8.decode(response.bodyBytes)); // Sử dụng utf8 để giải mã chuỗi dữ liệu JSON
    return jsonResponse.map((cartDetail) => CartDetail.fromJson(cartDetail)).toList();
  } else {
    // Nếu request thất bại, ném ra một exception
    throw Exception('Failed to load cart details');
  }
}

Future<Cart?> fetchCart(String email) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/cart/user/$email'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    if (body != null) {
      return Cart.fromJson(body);

    }
    return null;
  } else {
    throw Exception('Failed to fetch cart');
  }
}

Future<void> removeCartDetail(int id) async {
  final response = await http.delete(
    Uri.parse('$baseUrl/api/cartDetail/$id'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to delete cart detail');
  }
}
Future<CartDetail?> addToCart(CartDetail detail) async {
  final response = await http.post(
    Uri.parse('$baseUrl/api/cartDetail'), // Thay thế URL này bằng URL API thực của bạn
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(detail.toJson()),
  );
print(response.statusCode);
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return CartDetail.fromJson(jsonResponse);
  } else {
    throw Exception('Failed to add to cart');
  }
}

Future<CartDetail> updateCartDetail(CartDetail cartDetail) async {
  final response = await http.put(
    Uri.parse('$baseUrl/api/cartDetail'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(cartDetail.toJson()),
  );
  if (response.statusCode == 200) {
    return CartDetail.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 404) {
    throw Exception('Cart not found');
  } else {
    throw Exception('Failed to update cart detail');
  }
}
Future<CartDetail?> fetchCartDetailById(int cartDetailId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/api/cartDetail/$cartDetailId'), // Thay thế URL này bằng URL API thực của bạn
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    return CartDetail.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch cart detail by ID');
  }
}