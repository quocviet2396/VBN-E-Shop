import 'package:flutter/material.dart';
import '../controller/controllers.dart';
import '../view/home/components/cart_detail/cart_detail_screen.dart';
import '../view/home/components/favorite/favorite_screen.dart';


class MainHeader extends StatelessWidget {
  final Function(String) onSearch;

  const MainHeader({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            offset: const Offset(0, 0),
            blurRadius: 8,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    offset: const Offset(0, 0),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                autofocus: false,
                onSubmitted: (val) {
                  onSearch(val); // Gọi hàm callback khi tìm kiếm
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 16,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  hintText: "Search",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoriteScreen(email: authController.user.value?.email ?? 'No email',)), // Chuyển hướng sang FavoriteScreen
              );
            },
            child: Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.favorite,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsScreen(userEmail: authController.user.value?.email ?? 'No email'),
                ),
              );
            },
            child: Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    blurRadius: 8,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.grey,
              ),
            ),
          ),

          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
