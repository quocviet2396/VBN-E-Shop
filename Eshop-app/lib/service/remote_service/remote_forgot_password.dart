import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../const.dart';

 // Địa chỉ của máy chủ API

Future<void> sendToken(String email) async {
  final String apiUrl = '$baseUrl/api/auth/send-mail-forgot-password-token';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: jsonEncode({'email': email}), // Encode email as a JSON object
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Gửi thành công
      print('Email đã được gửi thành công để khôi phục mật khẩu.');
    } else if (response.statusCode == 404) {
      // Không tìm thấy email trong hệ thống
      print('Email không tồn tại trong hệ thống.');
    } else {
      // Xử lý các mã lỗi khác
      print('Đã xảy ra lỗi khi gửi yêu cầu: ${response.statusCode}');
    }
  } catch (e) {
    // Xử lý lỗi kết nối
    print('Đã xảy ra lỗi khi kết nối đến máy chủ: $e');
  }
}

void main() {
  sendToken('example@email.com'); // Thay đổi địa chỉ email thành địa chỉ cụ thể bạn muốn kiểm tra
}
