import 'package:eshop/const.dart';
import 'package:eshop/extension/string_extension.dart';
import 'package:eshop/model/emailrequest.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../../component/input_outline_button.dart';
import '../../../../../component/input_text_field.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool _isLoading = false;
  bool _isOtpSent = false;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    otpController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // Trong Flutter
  String _receivedOtp = '';
  Future<void> _sendOtp() async {

    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter your email')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final emailRequest = EmailRequest(email: emailController.text);
    final response = await http.post(
      Uri.parse('$baseUrl/api/send-mail/sendotpflutter'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(emailRequest.toJson()),
    );

    setState(() {
      _isLoading = false;
    });

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      setState(() {
        _isOtpSent = true;
        _receivedOtp = response.body;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP sent to your email')));
    } else {
      EasyLoading.showSuccess('Email already exists');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send OTP')));
    }
  }


  // Function to register the user
  // Function to register the user
  Future<void> _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Kiểm tra xem mã OTP đã nhập có rỗng không
      if (otpController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter OTP')));
        return;
      }

      // Kiểm tra xem mã OTP đã nhập có trùng với mã OTP gửi qua email hay không
      if (otpController.text != _receivedOtp) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP không hợp lệ. Vui lòng nhập đúng OTP')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          "userId":0,
          "registerDate": DateTime.now().toIso8601String(),
          "status": true,
          "gender": true,
          'name': fullNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'otp': otpController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful')));
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text("Register an account,",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
                const Text(
                  "Registration begins!",
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2),
                ),
                const Spacer(
                  flex: 3,
                ),
                InputTextField(
                  title: 'Enter email address',
                  textEditingController: emailController,
                  validation: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "This field can't be empty";
                    } else if (!value.isValidEmail) {
                      return "Please enter valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                if (_isOtpSent)
                  InputTextField(
                    title: 'OTP verification code',
                    textEditingController: otpController,
                    validation: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "This field can't be empty";
                      }
                      return null;
                    },
                  ),
                if (_isOtpSent) const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isOtpSent ? null : _sendOtp,
                  child: Text('Get otp authentication code'),
                ),
                if (_isOtpSent)
                  Column(
                    children: [
                      InputTextField(
                        title: 'Your full name',
                        textEditingController: fullNameController,
                        validation: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This field can't be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      InputTextField(
                        title: 'Password',
                        obsecureText: true,
                        textEditingController: passwordController,
                      ),
                      const SizedBox(height: 10),
                      InputTextField(
                        title: 'Phone number',
                        textEditingController: phoneController,
                        validation: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This field can't be empty";
                          } else if (value.length != 10 || !RegExp(r'^[0-9]+$').hasMatch(value)) {
                            return "Please enter a valid 10-digit phone number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      InputTextField(
                        title: 'Address',
                        textEditingController: addressController,
                        validation: (String? value) {
                          if (value == null || value.isEmpty) {
                            return "This field can't be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                const Spacer(),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isOtpSent ? () => _registerUser() : null,
                  child: Text("Register"),
                ),
                InputOutlineButton(
                  title: "Back",
                  onClick: () {
                    Navigator.of(context).pop();
                  },
                ),
                const Spacer(
                  flex: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("I have already registered, "),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                      },
                      child: const Text(
                        "Log in",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
