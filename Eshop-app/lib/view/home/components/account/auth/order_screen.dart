import 'package:eshop/controller/controllers.dart';
import 'package:eshop/model/order.dart';
import 'package:eshop/service/remote_service/remote_order_service.dart';
import 'package:eshop/view/home/components/order_detail/order_detail_slider.dart';
import 'package:flutter/material.dart';

class OrderListScreen extends StatefulWidget {
  final String email;

  OrderListScreen({required this.email});

  @override
  _OrderListScreenState createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late Future<List<Order>> _orderListFuture;

  @override
  void initState() {
    super.initState();
    _orderListFuture = getOrderList(widget.email);
  }

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Wait for confirmation';
      case 1:
        return 'Delivering';
      case 2:
        return 'Delivered';
      case 3:
        return 'Canceled';
      case 4:
        return 'Complete payment';
      default:
        return 'Unknown status';
    }
  }

  void _navigateToOrderDetail(Order order) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OrderDetailScreen(orderId: order.ordersId),
    ));
  }

  Future<void> _showCancelConfirmationDialog(Order order) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure to cancel the order?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
               child: Text(
                  'No',
                  style: TextStyle(color: Colors.black),
                ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelOrder(order);
              },
               child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.black),
                ),
            ),
          ],
        );
      },
    );
  }

  void _cancelOrder(Order order) async {
    try {
      // Gọi API hoặc service để hủy đơn hàng
      await cancelOrder(order.ordersId);
      // Sau khi hủy thành công, cập nhật lại danh sách đơn hàng
      setState(() {
        _orderListFuture = getOrderList(widget.email);
      });
      // Hiển thị thông báo hủy đơn hàng thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order #${order.ordersId} has been canceled successfully.'),
        ),
      );
    } catch (error) {
      // Xử lý trường hợp lỗi khi hủy đơn hàng
      print('Error while canceling order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while canceling the order. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of orders'),
      ),
      body: FutureBuilder<List<Order>>(
        future: _orderListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('Không có đơn hàng nào'));
          } else {
            // Hiển thị danh sách đơn hàng
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Order order = snapshot.data![index];
                return GestureDetector(
                  onTap: () => _navigateToOrderDetail(order), // Xử lý khi đơn hàng được chọn
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Code orders #${order.ordersId}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Order date: ${order.orderDate.toLocal().toString().split(' ')[0]}'),
                            Text('Total amount: ${order.amount.toStringAsFixed(0)}'),
                            Text('Phone number: ${order.phone}'),
                            Text('Delivery address: ${order.address}'),
                            Text('Status: ${getStatusText(order.status)}'),
                          ],
                        ),
                      ),
                      if (order.status == 0) // Hiển thị nút "Hủy đơn hàng" nếu trạng thái là Chờ xác nhận
                        ElevatedButton(
                          onPressed: () => _showCancelConfirmationDialog(order),
                          child: Text('Cancel order'),
                        ),
                      Divider(), // Đường kẻ giữa các đơn hàng
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}