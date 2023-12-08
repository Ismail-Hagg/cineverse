import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/view_controller.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  UserModel _model = UserModel();
  UserModel get model => _model;

  @override
  void onInit() {
    super.onInit();
    _model = Get.find<HomeController>().userModel;
  }

  // change app's theme
  void themeChange() async {
    ThemeMode mode = Get.isDarkMode ? ThemeMode.light : ThemeMode.dark;
    ChosenTheme theme = Get.isDarkMode ? ChosenTheme.light : ChosenTheme.dark;
    Get.changeThemeMode(mode);
    _model.theme = theme;
    await Get.find<AuthController>().saveUserDataLocally(model: _model).then(
      (value) async {
        await FirebaseServices().userUpdate(
          userId: _model.userId.toString(),
          map: {
            'theme': _model.theme.toString(),
          },
        );
      },
    );
  }

  // use uri launcher
  void launcherUse({required String url, required BuildContext context}) async {
    await launcherUrl(url: url).then((value) async {
      if (value.$1) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        await showOkAlertDialog(
            context: context, title: 'error'.tr, message: value.$2);
      }
    });
  }

  // uri launcher
  Future<(bool, String)> launcherUrl({required String url}) async {
    try {
      await canLaunchUrl(Uri.parse(url));
      return (true, '');
    } catch (e) {
      return (false, e.toString());
    }
  }

  // about
  void about({required BuildContext context, required Widget child}) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    platforMulti(
        isIos: isIos,
        title: "about".tr,
        buttonTitle: ['ok'.tr],
        body: '',
        func: [
          () {
            Get.back();
          }
        ],
        context: context,
        field: true,
        child: child);
  }

  // change the app's language
  void lanChange() async {
    String lang = _model.language == 'en_US' ? 'ar_SA' : 'en_US';
    await Get.updateLocale(Locale(lang.substring(0, 2), lang.substring(3, 5)))
        .then(
      (value) async {
        _model.language = lang;
        await Get.find<AuthController>()
            .saveUserDataLocally(model: _model)
            .then(
          (value) async {
            update();
            await FirebaseServices().userUpdate(
                userId: _model.userId.toString(),
                map: {
                  'language': lang
                }).then((_) => Get.find<HomeController>().apiCall());
          },
        );
      },
    );
  }

  // logout
  void logOut({
    required BuildContext context,
  }) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    platforMulti(
        isIos: isIos,
        title: "logoutq".tr,
        buttonTitle: ['cancel'.tr, "answer".tr],
        body: '',
        func: [
          () {
            Get.back();
          },
          () async {
            Get.find<AuthController>().signOut();
            Get.delete<SettingsController>();
            Get.delete<HomeController>();
            Get.offAll(const ViewController());
          }
        ],
        context: context);
  }
}
