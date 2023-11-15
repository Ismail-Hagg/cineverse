import 'package:cineverse/controllers/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfilePhone extends StatelessWidget {
  const ProfilePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Get.find<AuthController>().signOut(),
        child: Text('Profile Phone'),
      ),
    );
  }
}
