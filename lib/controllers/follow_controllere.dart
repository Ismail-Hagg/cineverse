import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/profile_controller.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/profile_page/profile_controller.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowController extends GetxController {
  List<String> _ids = [];
  List<String> get ids => _ids;

  final bool isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;

  final List<UserModel> _users = [];
  List<UserModel> get users => _users;

  String _title = '';
  String get title => _title;

  bool _loading = false;
  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    _ids = Get.arguments['ids'] ?? [];
    _title = Get.arguments['title'];
    getFollow();
  }

  // get the list of accounts
  void getFollow() async {
    _loading = true;
    update();
    if (_ids.isNotEmpty) {
      for (var i = 0; i < _ids.length; i++) {
        if (_ids[i] != '') {
          await FirebaseServices().getCurrentUser(userId: _ids[i]).then(
            (value) {
              _users.add(
                UserModel.fromMap(value.data() as Map<String, dynamic>),
              );
            },
          );
        }
      }
      _loading = false;
      update();
    }
  }

  // nav to profile
  void navProfile({required int index}) {
    Get.create(() => ProfilePageController());
    Get.to(() => (const ProfileViewController()),
        arguments: _users[index], preventDuplicates: false);
  }
}
