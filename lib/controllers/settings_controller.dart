import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/controllers/profile_controller.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/model_exports.dart';
import 'package:cineverse/pages/view_controller.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  UserModel _model = UserModel();
  UserModel get model => _model;

  final bool _isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  @override
  void onInit() {
    super.onInit();
    _model = Get.find<AuthController>().userModel;
  }

  @override
  void onClose() {
    super.onClose();
    _controller.dispose();
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
    await launcherUrl(url: url).then(
      (value) async {
        if (value.$1) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          platforMulti(
            isIos: _isIos,
            title: 'error'.tr,
            buttonTitle: ["ok".tr],
            body: value.$2,
            func: [
              () {
                Get.back();
              }
            ],
            context: context,
          );
        }
      },
    );
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

  // change the profile pic
  void changeProfilePic() async {
    await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']).then(
      (value) async {
        if (value != null) {
          // change data locally
          _model.avatarType = AvatarType.local;
          _model.localPicPath = value.files.single.path.toString();
          update();
          await DataPref().setUser(_model).then((value) async {
            // uploda new image to storage
            Get.find<HomeController>().update();
            Get.find<ProfilePageController>()
                .checking(pic: _model.localPicPath.toString());
            await FirebaseServices()
                .uploadUserImage(
                    userId: _model.userId.toString(),
                    file: _model.localPicPath.toString())
                .then(
              (link) async {
                update();
                if (link != '' && link != _model.localPicPath.toString()) {
                  // uploaded
                  _model.onlinePicPath = link;
                  await DataPref().setUser(_model).then(
                    (value) async {
                      // trigger firebase functtion to change user date and data in comments and replies and chats and notifications
                      UserChange change = UserChange(
                          avatarType: _model.avatarType.toString(),
                          userName: _model.userName.toString(),
                          link: link,
                          local: _model.localPicPath.toString(),
                          userId: _model.userId.toString());
                      await FirebaseServices()
                          .userChanging(map: change.toMap());
                    },
                  );
                }
              },
            );
          });
        }
      },
    );
  }

  // change user name
  void changeUserName({
    required BuildContext context,
    required Widget content,
  }) async {
    _isIos
        ? showCupertinoDialog(context: context, builder: (context) => content)
        // ignore: unused_result
        : showDialog(
            context: context,
            builder: (_) => content,
          );
  }

  // cancel and clear text controller
  void clearCancel() {
    Get.back();
    _controller.clear();
  }

  // ok , start changing the username
  void okChange() async {
    Get.back();
    if (_controller.text.trim() != '') {
      String newName = _controller.text.trim();
      _controller.clear();

      _model.userName = newName;
      update();
      Get.find<ProfilePageController>().update();
      await DataPref().setUser(_model).then((value) async {
        UserChange change = UserChange(
            avatarType: _model.avatarType.toString(),
            userName: _model.userName.toString(),
            link: _model.onlinePicPath.toString(),
            local: _model.localPicPath.toString(),
            userId: _model.userId.toString());
        await FirebaseServices().userChanging(map: change.toMap());
      });
    }
  }
}
