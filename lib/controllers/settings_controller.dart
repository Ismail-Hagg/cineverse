import 'dart:ui';

import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    await Get.find<AuthController>()
        .saveUserDataLocally(model: _model)
        .then((value) async {
      await FirebaseServices().userUpdate(
          userId: _model.userId.toString(),
          map: {'theme': _model.theme.toString()});
    });
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
}
