import 'package:cineverse/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeTablet extends StatelessWidget {
  const HomeTablet({super.key});

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>();
    return Scaffold(
      body: Center(
        child: GestureDetector(
            //onTap: () => controller.pray(),
            child: Text('Tablet View ${MediaQuery.of(context).size.width}')),
      ),
    );
  }
}
