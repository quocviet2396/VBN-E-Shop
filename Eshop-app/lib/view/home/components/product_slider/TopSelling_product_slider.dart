import 'package:eshop/view/home/components/product_slider/product_detail_slider.dart';
import 'package:flutter/material.dart';
import 'package:eshop/service/remote_service/remote_product_service.dart';
import 'package:eshop/model/product.dart'; // Import màn hình chi tiết sản phẩm

class TopSellingProductsScreen extends StatelessWidget {
  const TopSellingProductsScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final RemoteProductService productService = RemoteProductService();

    return FutureBuilder<List<Product>>(
      future: productService.fetchProduct(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        } else {
          List<Product> topSellingProducts = snapshot.data!;
          topSellingProducts.sort((a, b) => b.sold.compareTo(a.sold));
          topSellingProducts = topSellingProducts.take(10).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: topSellingProducts.map((product) {
                return GestureDetector(
                  onTap: () {
                    // Chuyển hướng đến màn hình chi tiết sản phẩm khi người dùng nhấn vào sản phẩm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Image.network(
                                product.image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              // Discount percentage text
                              if (product.discount > 0)
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
                                    ),
                                    child: Text(
                                      '-${product.discount}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text('Sold: ${product.sold} products'),
                          Text(
                            'price: ${product.discount > 0 ? (product.price * (1 - product.discount / 100)).toStringAsFixed(0) : (product.price % 1 == 0 ? product.price.toInt() : product.price.toStringAsFixed(2))} VND',
                            style: TextStyle(

                              color: product.discount > 0 ? Colors.red : null, // Màu sắc cho giá khuyến mãi nếu cần
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
