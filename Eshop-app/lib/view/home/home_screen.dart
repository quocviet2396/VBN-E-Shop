import 'package:flutter/material.dart';
import 'package:eshop/component/main_header.dart';
import 'package:eshop/view/home/components/carousel_slider/carousel_slider.dart';

import 'package:eshop/view/home/components/category/category_view_home.dart';
import 'package:eshop/view/home/components/product_slider/TopSelling_product_slider.dart';
import 'package:eshop/view/home/components/product_slider/new_product_slider.dart';
import 'package:eshop/view/home/components/product_slider/product_slider.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentIndex = 0;
  final List<String> imgList = [
    'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn/2024/05/banner/720x220-720x220-36.jpg',
    'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn/2024/05/banner/720x220-M15-720x220-1-720x220.jpg',
    'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn/2024/05/banner/720x220-720x220-75.png'
  ];

  void _onSearch(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductScreen(
          searchQuery: query,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Center(
          child: Column(
            children: [
              MainHeader(onSearch: _onSearch),
              const ImageCarousel(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const CategoryScreenHome(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Selling products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const TopSellingProductsScreen(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'New product',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const LatestProductsScreen(), // Thêm widget hiển thị sản phẩm bán chạy nhất
            ],
          ),
        ),
      ),
    );
  }
}
