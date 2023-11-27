import 'package:cineverse/controllers/profile_controller.dart';
import 'package:cineverse/pages/profile_page/profile_desktop.dart';
import 'package:cineverse/pages/profile_page/profile_phone.dart';
import 'package:cineverse/pages/profile_page/profile_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileViewController extends StatelessWidget {
  const ProfileViewController({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfilePageController controller = Get.put(ProfilePageController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const ProfilePhone()
        : width > phoneSize && width <= tabletSize
            ? const ProfileTablet()
            : const ProfileDesktop();
  }
}
