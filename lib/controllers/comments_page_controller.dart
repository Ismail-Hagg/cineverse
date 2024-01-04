import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/models/comment_model.dart';
import 'package:cineverse/models/profile_to_comment.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsPageController extends GetxController {
  final List<CommentModel> _commentsList = [];
  List<CommentModel> get commentList => _commentsList;

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  final bool isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;

  late ProfileToComment _model;
  ProfileToComment get model => _model;

  bool _loading = false;
  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    _model = Get.arguments ?? [];
    _userModel = _model.user;
    getComments();
  }

  // get comments
  void getComments() {
    _loading = true;
    update();
    _model.map.forEach((key, value) async {
      await FirebaseServices().getOtherComments(movieId: key).then((comment) {
        if (comment.docs.isNotEmpty) {
          for (var i = 0; i < comment.docs.length; i++) {
            if (value.contains(comment.docs[i].id)) {
              _commentsList.add(
                CommentModel.fromMap(
                    comment.docs[i].data() as Map<String, dynamic>),
              );
            }
          }
        }
      }).then((value) {
        _loading = false;
        update();
      });
    });
  }
}
