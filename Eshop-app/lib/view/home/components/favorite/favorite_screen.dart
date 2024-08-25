import 'package:flutter/material.dart';
import 'package:eshop/model/favorites.dart';
import 'package:eshop/service/remote_service/remote_favorite_service.dart';


import '../product_slider/product_detail_slider.dart'; // Import màn hình chi tiết sản phẩm

class FavoriteScreen extends StatelessWidget {
  final String email;

  const FavoriteScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    if (email == 'No email') {
      // Nếu email là null, chuyển hướng sang màn hình LoginScreen
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/signin');
      });
      return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites list'),
        ),
        body: Center(
          child: Text('Redirecting to Login...'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites list'),
      ),
      body: FutureBuilder<List<Favorite>>(
        future:  fetchFavorites(email),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {

            return Center(child: Text('Error: ${snapshot.error}'));

          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorites found'));
          } else {
            List<Favorite> favorites = snapshot.data!;
            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Chuyển hướng đến màn hình chi tiết sản phẩm khi người dùng nhấn vào sản phẩm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: favorites[index].product),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 50, // Kích thước cố định cho hình ảnh (ví dụ: 50x50)
                      height: 50,
                      child: Image.network(
                        favorites[index].product.image,
                        fit: BoxFit.cover, // Đảm bảo hình ảnh được căn chỉnh và không bị méo khi hiển thị
                      ),
                    ),
                    title: Text(favorites[index].product.name),
                    subtitle: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Text('Sell number: ${favorites[index].product.sold.toString()}'),
                        Text('Price: ${favorites[index].product.price.toStringAsFixed(0)}')

                      ],
                    ),
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
