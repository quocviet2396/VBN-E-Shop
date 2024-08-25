import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/controller/controllers.dart';
import 'package:eshop/model/cart_detail.dart';
import 'package:eshop/service/remote_service/remote_cartdetail_service.dart';
import 'package:eshop/service/remote_service/remote_favorite_service.dart';
import 'package:flutter/material.dart';
import 'package:eshop/model/product.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../../../model/cart.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;
  int? favoriteId;
  Cart? currentCart;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
    _fetchCurrentCart();
  }

  Future<void> _checkIfFavorite() async {
    try {
      final email=authController.user.value!.email;
      final isFav = await checkIfFavorite(widget.product.productId,email);
      final favorite = await fetchFavorite( widget.product.productId,email); // fetchFavorite should return the favorite item if it exists

          setState(() {
            isFavorite = isFav;
            favoriteId = favorite?.favoriteId;
          });





    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addToFavorites(int userId, int productId) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      await addToFavorite(userId, productId);
      setState(() {
        isFavorite = true;
      });
      EasyLoading.dismiss(); // Dismiss loading before showing success
      EasyLoading.showSuccess("Added to like list successfully");

    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss(); // Dismiss loading before showing error
      EasyLoading.showError('Failed to add to favorites. Try again!');
    }
  }

  Future<void> removeFromFavorites(int favoriteId) async {
    try {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
      await removeFavorite(favoriteId);
      setState(() {
        isFavorite = false;
      });
      EasyLoading.dismiss(); // Dismiss loading before showing success
      EasyLoading.showSuccess("Removed product name from favorites list");

    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss(); // Dismiss loading before showing error
      EasyLoading.showError('Failed to remove from favorites. Try again!');
    }
  }

  Future<void> _fetchCurrentCart() async {
    try {
      final email = authController.user.value!.email;
      final cart = await fetchCart(email);
      setState(() {
        currentCart = cart;
      });
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> _addToCart() async {
    double finalPrice;
    if (widget.product.discount > 0) {
      // Nếu có khuyến mãi, tính giá theo khuyến mãi
      finalPrice = widget.product.price * (1 - widget.product.discount / 100);
    } else {
      // Nếu không có khuyến mãi, sử dụng giá gốc của sản phẩm
      finalPrice = widget.product.price;
    }

    try {
      EasyLoading.show(
        status: 'Adding to cart...',
        dismissOnTap: false,
      );

      if (currentCart == null) {
        EasyLoading.showError('Please log in');
        return;
      }
      print(widget.product);

      final cartDetail = CartDetail(
        cartDetailId: 0,
        product: widget.product,
        cart: currentCart!,
        quantity: 1,
        price: finalPrice,

      );

      await addToCart(cartDetail);

      EasyLoading.dismiss();
      EasyLoading.showSuccess('Add to cart successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailScreen(product: widget.product)),

      );
    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
      EasyLoading.showError('Product is out of stock');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CachedNetworkImage(
                imageUrl: widget.product.image,
                width: MediaQuery.of(context).size.width,
                height: 400,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              RichText(
                text: TextSpan(
                  text: 'Price: ',
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: '${widget.product.price % 1 == 0 ? widget.product.price.toInt() : widget.product.price} VND',
                      style: TextStyle(
                        decoration: widget.product.discount > 0 ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (widget.product.discount > 0) // Show discounted price if available
                      TextSpan(
                        text: ' Discount price: ${(widget.product.price * (1 - widget.product.discount / 100)).toStringAsFixed(0)} VND',
                        style: const TextStyle(
                          color: Colors.red, // or any other color you want for discounted price
                        ),
                      ),
                  ],
                ),
              ),
               const SizedBox(height: 8),
              Text(
                'Sell number: ${widget.product.sold}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'Description:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                widget.product.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  widget.product.quantity == 0
                      ? const Text(
                    'Out of stock',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
                  )
                      : IconButton(
                    icon: const Icon(Icons.add_shopping_cart),
                    iconSize: 60,
                    onPressed: () {
                      _addToCart();
                    },
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                    iconSize: 60,
                    onPressed: () async {
                      if (isFavorite) {
                        await removeFromFavorites(favoriteId!);
                      } else {
                        await addToFavorites(authController.user.value!.id, widget.product.productId);
                      }
                      // Reload the page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailScreen(product: widget.product)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
