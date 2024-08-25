import 'package:eshop/controller/controllers.dart';
import 'package:eshop/controller/dasboard_controller.dart';
import 'package:eshop/view/home/components/PriceGuessingGame/priceguessinggame_slider.dart';
// Import AuthController
import 'package:eshop/view/home/components/account/account_screen.dart';
import 'package:eshop/view/home/components/favorite/favorite_screen.dart';
import 'package:eshop/view/home/components/product_slider/product_slider.dart';
import 'package:eshop/view/home/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {

  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {

    return GetBuilder<DashboardController>(
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: controller.tabIndex,
            children: [
              const HomeScreen(),
              const ProductScreen(searchQuery: null), // Gửi null thay vì chuỗi rỗng
              PriceGuessingGame(),
              // FavoriteScreen(email: authController.user.value?.email??"aa"),
              const AccountScreen(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 0.7
                  )
              )
          ),
          child: SnakeNavigationBar.color(
            behaviour: SnakeBarBehaviour.floating,
            snakeShape: SnakeShape.circle,
            padding: const EdgeInsets.symmetric(vertical: 5),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            snakeViewColor: Theme.of(context).primaryColor,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            showUnselectedLabels: true,
            currentIndex: controller.tabIndex,
            onTap: (val){
              controller.updateIndex(val);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Products'),
              BottomNavigationBarItem(icon: Icon(Icons.games), label: 'Game'),
              BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Account')
            ],
          ),
        ),
      ),
    );
  }
}
