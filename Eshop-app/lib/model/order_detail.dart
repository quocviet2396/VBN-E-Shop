import 'package:eshop/model/order.dart';
import 'package:eshop/model/product.dart';

class OrderDetail {
  final int orderDetailId;
  final int quantity;
  final double price;
  final Product product;
  final Order order;

  OrderDetail({
    required this.orderDetailId,
    required this.quantity,
    required this.price,
    required this.product,
    required this.order,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderDetailId: json['orderDetailId'],
      quantity: json['quantity'],
      price: json['price'],
      product: Product.fromJson(json['product']),
      order: Order.fromJson(json['order']),
    );
  }
}