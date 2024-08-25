import 'dart:convert';
import 'package:eshop/model/userInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';


import '../model/user.dart';
import '../service/remote_service/remote_auth_service.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  Rxn<User> user = Rxn<User>();
  Rxn<UserIf> userif= Rxn<UserIf>();


  void signUp({required String fullName, required String email, required String password}) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteAuthService().signUp(
        email: email,
        password: password,
      );
      if(result.statusCode == 200) {
        String token = json.decode(result.body)['jwt'];
        var userResult = await RemoteAuthService().createProfile(fullName: fullName, token: token);
        if(userResult.statusCode == 200) {
          EasyLoading.showSuccess("Welcome to MyGrocery!");
          Navigator.of(Get.overlayContext!).pop();
        } else {
          EasyLoading.showError('Something wrong. Try again!');
        }
      } else {
        EasyLoading.showError('Something wrong. Try again!');
      }
    } catch(e){
      EasyLoading.showError('Something wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }

  void signIn({required String email, required String password}) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      var result = await RemoteAuthService().signIn(
        email: email,
        password: password,
      );
      if (result.statusCode == 200) {
        var responseBody = json.decode(utf8.decode(result.bodyBytes)); // Sử dụng utf8 để giải mã dữ liệu nhận được từ server
        String? token = responseBody['token']; // Lưu ý kiểu dữ liệu String?
        int? userId= responseBody['id'];
        String? email= responseBody['email'];

         // Lưu ý kiểu dữ liệu int?
        print(email);
        print(userId);
        print('Token: $token');

        // Kiểm tra xem token và userId có null không trước khi gán
        if (token != null) {
          user.value = User.fromJson(responseBody); // Lưu thông tin người dùng vào biến user

          EasyLoading.showSuccess("Đăng nhập thành công");
          Navigator.of(Get.overlayContext!).pop();
        } else {
          EasyLoading.showError('Token or userId is null'); // Xử lý trường hợp token hoặc userId là null
        }
      } else {
        EasyLoading.showError('Mật khẩu hoặc tài khoảng sai');
      }
    } catch (e) {
      debugPrint(e.toString());
      EasyLoading.showError('Something went wrong. Try again!');
    } finally {
      EasyLoading.dismiss();
    }
  }




  void signOut() {
    user.value = null; // Xóa thông tin người dùng khi đăng xuất
  }
}
