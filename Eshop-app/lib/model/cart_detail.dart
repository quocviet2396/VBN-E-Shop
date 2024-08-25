import 'product.dart';
import 'cart.dart';

class CartDetail {
  final int cartDetailId;
  late final int quantity;
  final double price;
  final Product product;
  final Cart cart;

  CartDetail({
    required this.cartDetailId,
    required this.quantity,
    required this.price,
    required this.product,
    required this.cart,
  });

  factory CartDetail.fromJson(Map<String, dynamic> json) {
    return CartDetail(
      cartDetailId: json['cartDetailId'],
      quantity: json['quantity'],
      price: json['price'].toDouble(),
      product: Product.fromJson(json['product']),
      cart: Cart.fromJson(json['cart']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'cartDetailId': cartDetailId,
      'cart': cart.toJson(),
      'product': product.toJson(),
      'quantity': quantity,
      'price': price,
    };
  }
}
