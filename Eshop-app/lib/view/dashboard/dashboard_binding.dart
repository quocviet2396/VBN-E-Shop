import 'package:get/get.dart';

import '../../controller/dasboard_controller.dart';


class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}