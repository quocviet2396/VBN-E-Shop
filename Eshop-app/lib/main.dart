import 'package:eshop/route/app_page.dart';
import 'package:eshop/route/app_route.dart';
import 'package:eshop/theme/app_theme.dart';
import 'package:eshop/view/home/components/PriceGuessingGame/WheelOfFortune.dart';
import 'package:eshop/view/home/components/account/auth/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'controller/auth_controller.dart';

void main(){
  configLoading();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      getPages: AppPage.list,
      initialRoute: AppRoute.dashboard,
      routes: {
        '/signin': (context) => SignInScreen(),
        '/spinWheel': (context) => SpinWheel(),// Định nghĩa SignInScreen
        // Các định nghĩa route khác
      },
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      builder: EasyLoading.init(),
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    );
  }
}

void configLoading(){
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..userInteractions = false
    ..maskType = EasyLoadingMaskType.black
    ..dismissOnTap = true;
}

