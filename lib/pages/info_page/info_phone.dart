import 'package:cineverse/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoPhone extends StatelessWidget {
  const InfoPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Get.find<AuthController>().signOut(),
          child: Text(
              'Phone Info ${Get.find<AuthController>().userModel.phoneNumber}'),
        ),
      ),
    );
  }
}
