import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../const.dart';
import '../../model/userInfo.dart';

class RemoteAuthService {
  var client = http.Client();

  Future<dynamic> signUp({
    required String email,
    required String password,
  }) async {
    var body = {"username": email, "email": email, "password": password};
    var response = await client.post(
      Uri.parse('$baseUrl/api/auth/local/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<dynamic> createProfile({
    required String fullName,
    required String token,
  }) async {
    var body = {"fullName": fullName};
    var response = await client.post(
      Uri.parse('$baseUrl/api/profile/me'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode(body),
    );
    return response;
  }


  // Phương thức đăng nhập
  Future<dynamic> signIn({required String email, required String password}) async {
    var response = await client.post(
      Uri.parse('$baseUrl/api/auth/signin'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    return response;
  }

  // Phương thức lấy thông tin người dùng
  Future<UserIf?> getProfile({
    required String token,
  }) async {
    try {
      var response = await client.get(
        Uri.parse('$baseUrl/api/auth/profile'), // Đường dẫn API để lấy thông tin người dùng
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        // Sử dụng utf8 để giải mã JSON
        var responseBody = json.decode(utf8.decode(response.bodyBytes));
        return UserIf.fromJson(responseBody);
      } else {
        // Xử lý các trường hợp khác, ví dụ: lỗi server, không tìm thấy người dùng, v.v.
        return null;
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error while fetching user profile: $e');
      return null;
    }
  }

}
