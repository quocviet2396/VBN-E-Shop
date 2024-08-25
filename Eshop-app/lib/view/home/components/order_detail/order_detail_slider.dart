import 'package:eshop/service/remote_service/remote_orderdetail_service.dart';
import 'package:flutter/material.dart';
import 'package:eshop/model/order_detail.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  OrderDetailScreenState createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  late Future<List<OrderDetail>> _orderDetailsFuture;
  final String placeholderImage = ''; // Đường dẫn của hình ảnh tạm thời

  @override
  void initState() {
    super.initState();
    _orderDetailsFuture = getOrderDetails(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: FutureBuilder<List<OrderDetail>>(
        future: _orderDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Build UI with order details
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                OrderDetail orderDetail = snapshot.data![index];
                return ListTile(
                  leading: FadeInImage.assetNetwork(
                    placeholder: placeholderImage,
                    image: orderDetail.product.image,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(orderDetail.product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ${orderDetail.price}'),
                      Text('Quantity: ${orderDetail.quantity}'),
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
