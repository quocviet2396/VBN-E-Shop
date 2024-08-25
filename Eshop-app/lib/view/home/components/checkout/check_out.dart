import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:eshop/model/cart.dart';
import 'package:eshop/service/remote_service/remote_order_service.dart';
import 'package:eshop/service/remote_service/remote_cart_service.dart';


class EditCartScreen extends StatefulWidget {
  final String userEmail;
  final Cart cart;

  const EditCartScreen({
    Key? key,
    required this.userEmail,
    required this.cart,
  }) : super(key: key);

  @override
  _EditCartScreenState createState() => _EditCartScreenState();
}

class _EditCartScreenState extends State<EditCartScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _addressController = TextEditingController(text: utf8.decode(widget.cart.address.codeUnits));
    _phoneController = TextEditingController(text: widget.cart.phone);
  }

  void _editAndCheckout() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Edit Cart
        final Cart updatedCart = await updateCart(
          widget.userEmail,
          Cart(
            cartId: widget.cart.cartId,
            amount:  widget.cart.amount,
            address: _addressController.text,
            phone: _phoneController.text,
            user: widget.cart.user,
          ),
        );
        print('Cart updated successfully: $updatedCart');

        // Checkout
        final bool order = await checkout(widget.userEmail, updatedCart);
        print('Checkout successful: $order');
        EasyLoading.showSuccess("Checkout successful");

        // Chuyển hướng về trang chủ
        Navigator.pushReplacementNamed(context, '/home'); // Đặt tên đúng của trang chủ
      } catch (e) {
        print('Error: $e');
        EasyLoading.showSuccess("Your cart has product out of stock");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer address information'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                initialValue: utf8.decode(widget.cart.user.name.codeUnits),
                readOnly: true, // Không cho phép chỉnh sửa
                decoration: InputDecoration(labelText: 'Full name'),
              ),

              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address of the store'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Phone number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _editAndCheckout,
                child: Text('Confirm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
