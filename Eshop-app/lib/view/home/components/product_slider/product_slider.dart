import 'package:eshop/view/home/components/product_slider/product_detail_slider.dart';
import 'package:flutter/material.dart';
import 'package:eshop/model/product.dart';
import 'package:eshop/service/remote_service/remote_product_service.dart';
import 'package:eshop/view/home/components/category/category_slider.dart';
import 'package:eshop/component/main_header.dart';

class ProductScreen extends StatefulWidget {
  final String? searchQuery;

  const ProductScreen({super.key, this.searchQuery});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedCategoryId = 1; // Default categoryId
  String? searchQuery;

  @override
  void initState() {
    super.initState();
    searchQuery = widget.searchQuery;
  }

  void _onSearch(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final RemoteProductService productService = RemoteProductService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('List of products'),
      ),
      body: Column(
        children: [
          MainHeader(onSearch: _onSearch),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productService.fetchProduct(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found'));
                } else {
                  List<Product> products;

                  if (searchQuery != null && searchQuery!.isNotEmpty) {
                    // Search products by name
                    products = snapshot.data!
                        .where((product) => product.name.toLowerCase().contains(searchQuery!.toLowerCase()))
                        .toList();
                  } else {
                    // Filter products by selectedCategoryId
                    products = snapshot.data!
                        .where((product) => product.category.categoryId == selectedCategoryId)
                        .toList();
                  }

                  return Column(
                    children: [
                      CategoryScreen(
                        onCategorySelected: (categoryId) {
                          setState(() {
                            selectedCategoryId = categoryId; // Update selectedCategoryId
                          });
                        },
                      ), // Use CategoryScreen widget here
                      Expanded(
                        child: ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to the product detail screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                              child: Card(
                                child: ListTile(
                                  leading: Stack(
                                    children: [
                                      Image.network(
                                        product.image,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                      if (product.discount > 0) // Show discount percentage if available
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
                                  title: Text(product.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Sold: ${product.sold} product'),
                                      RichText(
                                        text: TextSpan(
                                          text: 'Price: ',
                                          style: DefaultTextStyle.of(context).style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: '${product.price % 1 == 0 ? product.price.toInt() : product.price} VND',
                                              style: TextStyle(
                                                decoration: product.discount > 0 ? TextDecoration.lineThrough : null,
                                              ),
                                            ),
                                            if (product.discount > 0) // Show discounted price if available
                                              TextSpan(
                                                text: ' Discount price: ${(product.price * (1 - product.discount / 100)).toStringAsFixed(0)} VND',
                                                style: const TextStyle(
                                                  color: Colors.red, // or any other color you want for discounted price
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
