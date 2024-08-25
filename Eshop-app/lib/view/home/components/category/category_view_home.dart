import 'package:flutter/material.dart';
import 'package:eshop/service/remote_service/remote_category_service.dart';
import 'package:eshop/model/category.dart';

class CategoryScreenHome extends StatelessWidget {


  const CategoryScreenHome({super.key});

  // Các phần code khác không thay đổi
  final Map<int, String> categoryImages = const {
    1: 'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn//content/icon-phone-96x96-2.png',
    2: 'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn//content/icon-laptop-96x96-1.png',
    3: 'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn//content/icon-tablet-96x96-1.png',
    4: 'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn//content/watch-icon-96x96.png',
    5: 'https://static.vecteezy.com/system/resources/previews/000/582/064/original/tv-icon-vector-illustration.jpg',
  };

  @override
  Widget build(BuildContext context) {
    final RemoteCategoryService categoryService = RemoteCategoryService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Category>>(
          future: categoryService.fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No categories found'));
            } else {
              final categories = snapshot.data!;
              return SizedBox(
                height: 150.0, // Chiều cao của ListView ngang
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final imageUrl = categoryImages[category.categoryId] ??
                        'https://img.tgdd.vn/imgt/f_webp,fit_outside,quality_100/https://cdn.tgdd.vn//content/PC-24x24.png'; // URL hình ảnh mặc định
                    return Container(
                      width: 120.0, // Chiều rộng của mỗi mục trong ListView
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            category.categoryName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
