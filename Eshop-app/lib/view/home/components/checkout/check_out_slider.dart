import 'package:eshop/model/order.dart';
import 'package:eshop/service/remote_service/remote_order_service.dart';
import 'package:flutter/material.dart';

import '../../../../model/cart.dart';


class CheckOutScreen extends StatefulWidget {
  final String userEmail;
  final Cart cart;

  const CheckOutScreen({
    Key? key,
    required this.userEmail,
    required this.cart,
  }) : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  bool _isLoading = false;

  void _checkout() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final bool order = await checkout(widget.userEmail, widget.cart);

      print('Checkout successful: $order');
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error during checkout: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Total Amount: ${widget.cart.amount}', // Hiển thị tổng số tiền của đơn hàng
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _checkout,
              child: Text('Confirm Order'),
            ),
          ],
        ),
      ),
    );
  }
}
