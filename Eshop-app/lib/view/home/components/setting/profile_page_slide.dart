import 'package:eshop/const.dart';
import 'package:eshop/controller/controllers.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditProfileScreen extends StatefulWidget {
  final int userId;

  EditProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  bool _isMale = true; // Default to Male

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> getUserDetails() async {
    try {
      var response = await http.get(Uri.parse('$baseUrl/api/auth/${widget.userId}'));

      if (response.statusCode == 200) {
        var userData = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _nameController.text = userData['name'];
          _phoneController.text = userData['phone'];
          _addressController.text = userData['address'];
          _isMale = userData['gender'] ?? true; // Default to true if gender is not defined
        });
      } else {
        EasyLoading.showError('Failed to load user details. Status code: ${response.statusCode}');
        print('Failed to load user details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.showError('Exception occurred: $e');
      print('Exception occurred: $e');
    }
  }

  Future<void> updateUser(int userId) async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String phone = _phoneController.text;
      String address = _addressController.text;

      var userData = {
        'userId': userId,
        'name': name,
        'email': authController.user.value!.email,
        'phone': phone,
        'address': address,
        'password': authController.user.value!.password,
        'image': authController.user.value!.image,
        'token': authController.user.value!.token,
        'registerDate': authController.user.value!.registerDate,
        'status': authController.user.value!.status,
        'gender': _isMale, // Ensure this matches your API schema
      };


      try {
        var url = Uri.parse('$baseUrl/api/auth/$userId');

        var response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(userData),
        );

        if (response.statusCode == 200) {
          EasyLoading.showSuccess("User updated successfully");
          print('User updated successfully');
          Navigator.pop(context); // Navigate back after successful update
        } else {
          EasyLoading.showError('Failed to update user. Status code: ${response.statusCode}');
          print('Failed to update user. Status code: ${response.statusCode}');
        }
      } catch (e) {
        EasyLoading.showError('Error updating user: $e');
        print('Error updating user: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Phone number must be at least 10 digits';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Gender', style: TextStyle(fontSize: 18)),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Male'),
                      leading: Radio(
                        value: true,
                        groupValue: _isMale,
                        onChanged: (value) {
                          setState(() {
                            _isMale = value ?? true;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Female'),
                      leading: Radio(
                        value: false,
                        groupValue: _isMale,
                        onChanged: (value) {
                          setState(() {
                            _isMale = value ?? false;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  updateUser(widget.userId);
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
