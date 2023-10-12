import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/pages/home_page/home_controller.dart';
import 'package:cineverse/pages/info_page/info_controller.dart';
import 'package:cineverse/pages/login_page/login_controller.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ViewController extends StatelessWidget {
  const ViewController({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: Get.find<AuthController>(),
      builder: (controll) => controll.user == null
          ? const LoginController()
          : controll.userModel.state == LogState.info
              ? const InfoController()
              : const HomePageController(),
    );
  }
}
