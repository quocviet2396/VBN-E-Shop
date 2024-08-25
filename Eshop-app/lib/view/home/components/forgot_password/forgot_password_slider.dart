import 'package:eshop/extension/string_extension.dart';
import 'package:eshop/view/home/components/forgot_password/reset_password_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:eshop/const.dart'; // Đảm bảo import baseUrl từ file const.dart

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Key để quản lý Form

  void sendOTP(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Nếu form hợp lệ thì tiếp tục gửi OTP
      String email = emailController.text.trim();
      var url = Uri.parse('$baseUrl/forgot'); // Sử dụng baseUrl từ file const.dart
      try {
        var response = await http.post(url, body: {'email': email});
        print(response.statusCode);

        if (response.statusCode == 200) {
          // Hiển thị màn hình ResetPasswordSlider và truyền dữ liệu email
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(email: email),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send OTP: ${response.body}')),
          );
        }
      } catch (e) {
        print('Error sending OTP: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP. Please try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Gán key cho Form
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This field can't be empty";
                  } else if (!value.isValidEmail) {
                    return "Please enter valid email";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => sendOTP(context),
                child: Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
