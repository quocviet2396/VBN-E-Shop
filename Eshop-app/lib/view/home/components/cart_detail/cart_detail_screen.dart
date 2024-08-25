import 'package:eshop/controller/controllers.dart';
import 'package:eshop/view/home/components/checkout/check_out.dart';
import 'package:eshop/view/home/components/checkout/check_out_slider.dart';
import 'package:eshop/view/home/components/product_slider/product_detail_slider.dart';
import 'package:flutter/material.dart';
import 'package:eshop/model/cart.dart';
import 'package:eshop/model/cart_detail.dart';
import 'package:eshop/service/remote_service/remote_cartdetail_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String userEmail;

  const OrderDetailsScreen({super.key, required this.userEmail});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late Future<Cart?> _cartFuture;
  late Future<List<CartDetail>> _cartDetailFuture;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }
  Future<void> _removeCartDetail(int cartDetailId) async {
    try {
      await removeCartDetail(cartDetailId);
      // Cập nhật lại giỏ hàng sau khi xóa mục
      final cart = await _cartFuture;
      if (cart != null) {
        await _fetchCartDetails(cart.cartId);
      }
    } catch (e) {
      print('Error removing cart detail: $e');
    }
  }
  Future<void> _fetchCart() async {
    setState(() {
      _cartFuture = fetchCart(widget.userEmail) ;
    });
  }

  Future<void> _fetchCartDetails(int cartId) async {
    setState(() {
      _cartDetailFuture = fetchCartDetailsById(cartId);
    });
  }
  double _TotalPrice_product(List<CartDetail> cartDetails) {
    double total = 0.0;
    for (var cartDetail in cartDetails) {
      total += cartDetail.product.price * cartDetail.quantity;
    }
    return total;
  }

  double _calculateTotalPrice(List<CartDetail> cartDetails) {
    double total = 0.0;
    for (var detail in cartDetails) {
      total += detail.price;
    }
    return total;
  }



  Future<void> _updateCartDetailQuantity(int cartDetailId, int newQuantity) async {
    try {
      // Fetch cart detail by id
      final cartDetail = await fetchCartDetailById(cartDetailId);

      if (cartDetail != null) {
        double priceDiscount; // Giá sau khi áp dụng khuyến mãi

        if (cartDetail.product.discount > 0) {
          // Nếu có khuyến mãi, tính giá sau khi áp dụng khuyến mãi
          priceDiscount = cartDetail.product.price * (1 - cartDetail.product.discount / 100);
        } else {
          // Nếu không có khuyến mãi, giữ nguyên giá gốc của sản phẩm
          priceDiscount = cartDetail.product.price;
        }

        // Tính toán giá mới dựa trên giá sau khi áp dụng khuyến mãi và số lượng mới
        final updatedPrice = priceDiscount * newQuantity;

        // Kiểm tra nếu số lượng mới vượt quá số lượng sản phẩm hiện có
        if (newQuantity > cartDetail.product.quantity) {
          // Hiển thị thông báo cho người dùng (hoặc thực hiện hành động phù hợp)
          print('Cannot add more than available quantity: ${cartDetail.product.quantity}');
          return;
        }

        // Tạo một đối tượng CartDetail mới với số lượng được cập nhật và giá mới
        final updatedCartDetail = CartDetail(
          cartDetailId: cartDetail.cartDetailId,
          product: cartDetail.product,
          quantity: newQuantity,
          price: updatedPrice,
          cart: cartDetail.cart,
        );

        // Gọi hàm cập nhật chi tiết giỏ hàng với thông tin mới
        await updateCartDetail(updatedCartDetail);

        // Sau khi cập nhật thành công, làm mới danh sách chi tiết giỏ hàng
        final cart = await _cartFuture;
        if (cart != null) {
          await _fetchCartDetails(cart.cartId);
        }
      }
    } catch (e) {
      print('Error updating cart detail quantity: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: FutureBuilder<Cart?>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No order found.'));
          } else {
            final cart = snapshot.data!;
            _fetchCartDetails(cart.cartId); // Lấy danh sách chi tiết đơn hàng sau khi đã có thông tin về đơn hàng
            return FutureBuilder<List<CartDetail>>(
              future: _cartDetailFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No items in order.'));
                } else {
                  final cartDetails = snapshot.data!;
                  final totalPrice = _calculateTotalPrice(cartDetails);
                  final totalPriceProduct = _TotalPrice_product(cartDetails);
                  // Hiển thị danh sách các mục trong đơn hàng
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: cartDetails.length,
                          itemBuilder: (context, index) {
                            final cartDetail = cartDetails[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the product detail screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(product: cartDetail.product),
                                  ),
                                );
                              },
                              child: ListTile(
                                leading: Image.network(
                                  cartDetail.product.image,
                                  width: 60, // Set the width of the image
                                  height: 60, // Set the height of the image
                                  fit: BoxFit.cover, // Adjust the image to cover the space
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartDetail.product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Total price: ${cartDetail.price.toStringAsFixed(0)} VND', // Thay đổi nội dung theo yêu cầu của bạn
                                      style: TextStyle(
                                        color: Colors.black, // Tuỳ chỉnh màu sắc nếu cần
                                        fontSize: 14, // Tuỳ chỉnh kích thước phù hợp
                                      ),
                                    ),
                                    if (cartDetail.product.quantity == 0)
                                      Text(
                                        'Out of stock',
                                        style: TextStyle(
                                          color: Colors.red, // Tuỳ chỉnh màu sắc nếu cần
                                          fontSize: 14, // Tuỳ chỉnh kích thước phù hợp
                                        ),
                                      ),
                                  ],
                                ),

                                subtitle: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (cartDetail.quantity > 1) {
                                          // Giảm số lượng đi 1 nếu lớn hơn 1
                                          _updateCartDetailQuantity(cartDetail.cartDetailId, cartDetail.quantity - 1);
                                        }
                                      },
                                    ),
                                    Text(cartDetail.quantity.toString()), // Hiển thị số lượng
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        // Tăng số lượng lên 1
                                        _updateCartDetailQuantity(cartDetail.cartDetailId, cartDetail.quantity + 1);
                                      },
                                    ),

                                  ],
                                ),


                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [

                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        await _removeCartDetail(cartDetail.cartDetailId);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );

                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Total Price: ${totalPriceProduct.toStringAsFixed(0)} VND',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Save money: ${(totalPriceProduct - totalPrice).toStringAsFixed(0)} VND',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),


                            Text(
                              'The total amount payable: ${totalPrice.toStringAsFixed(0)} VND',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16), // Add some space between the text and the button
                            ElevatedButton(
                              onPressed: () {
                                // Sử dụng Navigator.push để chuyển đến trang CheckoutScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditCartScreen(
                                      userEmail: authController.user.value!.email,
                                      cart: cart,
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                minimumSize: const Size(double.infinity, 36), // Full width button
                              ),
                              child: const Text('Order'),
                            ),

                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
