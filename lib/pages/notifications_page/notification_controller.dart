import 'package:cineverse/controllers/notifications_controller.dart';
import 'package:cineverse/pages/notifications_page/notification_desktop.dart';
import 'package:cineverse/pages/notifications_page/notification_tablet.dart';
import 'package:cineverse/pages/notifications_page/notificato_phone.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsViewController extends StatelessWidget {
  const NotificationsViewController({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationsController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const NotificationsPhone()
        : width > phoneSize && width <= tabletSize
            ? const NotificationsTablet()
            : const NotificationsDesktop();
  }
}
