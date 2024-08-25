import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eshop/const.dart'; // Đường dẫn tới file const.dart
import 'package:eshop/model/user.dart'; // Đường dẫn tới model User.dart

Future<Map<String, dynamic>?> updateUser(int userId, Map<String, dynamic> userData) async {
  var url = Uri.parse('$baseUrl/api/auth/$userId');

  try {
    var response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Thêm các header khác nếu cần thiết
      },
      body: json.encode(userData),
    );

    if (response.statusCode == 200) {
      // Nếu cập nhật thành công, bạn có thể xử lý và trả về dữ liệu cập nhật
      var updatedUser = json.decode(response.body);
      return updatedUser;
    } else {
      // Xử lý khi không thành công (ví dụ: in ra lỗi)
      print('Failed to update user. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Xử lý các ngoại lệ (ví dụ: in ra ngoại lệ)
    print('Exception occurred: $e');
    return null;
  }
}
