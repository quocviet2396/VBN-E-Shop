import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key});

  final List<String> imgList = const [
    'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn/2024/05/banner/720x220-720x220-36.jpg',
    'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn/2024/05/banner/720x220-M15-720x220-1-720x220.jpg',
    'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn/2024/05/banner/720x220-720x220-75.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
          ),
          items: imgList.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Image.network(item, fit: BoxFit.cover),
                );
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () {
                // Handle tap if needed, but no state change
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),  // Default color, no state change
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
