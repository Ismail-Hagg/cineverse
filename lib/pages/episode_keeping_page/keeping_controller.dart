import 'package:cineverse/controllers/keeping_controller.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_desktop.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_phone.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class KeepingViewController extends StatelessWidget {
  const KeepingViewController({super.key});

  @override
  Widget build(BuildContext context) {
    final KeepingController controller = Get.put(KeepingController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const KeepingPhone()
        : width > phoneSize && width <= tabletSize
            ? const KeepingTablet()
            : const KeepingDesktop();
  }
}
