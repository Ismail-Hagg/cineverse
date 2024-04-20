import 'package:cineverse/controllers/settings_controller.dart';
import 'package:cineverse/pages/settings_page/settings_desktop.dart';
import 'package:cineverse/pages/settings_page/settings_phone.dart';
import 'package:cineverse/pages/settings_page/settings_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SettingsViewController extends StatelessWidget {
  const SettingsViewController({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const SettingsPhone()
        : width > phoneSize && width <= tabletSize
            ? const SettingsTablet()
            : const SettingsDesktop();
  }
}
