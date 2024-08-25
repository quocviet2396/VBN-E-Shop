import 'package:eshop/view/home/components/product_slider/product_detail_slider.dart';
import 'package:flutter/material.dart';
import 'package:eshop/service/remote_service/remote_product_service.dart';
import 'package:eshop/model/product.dart';

class LatestProductsScreen extends StatelessWidget {
  const LatestProductsScreen({super.key,});

  @override
  Widget build(BuildContext context) {
    final RemoteProductService productService = RemoteProductService();

    return FutureBuilder<List<Product>>(
      future: productService.fetchLatestProducts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No latest products found'));
        } else {
          List<Product> latestProducts = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: latestProducts.map((product) {
                return GestureDetector(
                  onTap: () {
                    // Chuyển hướng sang màn hình chi tiết sản phẩm
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
                          Text('Sold : ${product.sold} products'),
                          Text(
                            'Price: ${product.discount > 0 ? (product.price * (1 - product.discount / 100)).toStringAsFixed(0) : (product.price % 1 == 0 ? product.price.toInt() : product.price.toStringAsFixed(2))} VND',
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
