import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/profile_controller.dart';
import 'package:cineverse/models/model_exports.dart';
import 'package:cineverse/pages/chat/chat_page_controller.dart';
import 'package:cineverse/pages/profile_page/profile_controller.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  late Stream<QuerySnapshot> _chatStream;
  Stream<QuerySnapshot> get straem => _chatStream;

  final bool _isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  List<ChatMessageModel> _lst = [];
  List<ChatMessageModel> get lst => _lst;

  @override
  void onInit() {
    super.onInit();
    _userModel = Get.find<AuthController>().userModel;

    _chatStream = FirebaseServices().getAllChats(
      userId: _userModel.userId.toString(),
    );
  }

  // put data in object list
  void gatherData({required List<QueryDocumentSnapshot> chats}) {
    if (chats.isNotEmpty) {
      _lst = [];
      for (var i = 0; i < chats.length; i++) {
        _lst.add(
            ChatMessageModel.fromMap(chats[i].data() as Map<String, dynamic>));
      }
      _lst.sort((a, b) => b.change.compareTo(a.change));
    }
  }

  // nav to chat page
  void navChat({required int index}) {
    Get.to(() => const ChatPageViewController(),
        arguments: UserModel(
            userId: _lst[index].userId, userName: _lst[index].userNsme));
  }

  // nav to profile
  void navProfile({required int index}) {
    Get.create(() => ProfilePageController());
    Get.to(() => (const ProfileViewController()),
        arguments: UserModel(
            isError: false,
            avatarType: AvatarType.online,
            movieWatchList: [],
            favs: [],
            showWatchList: [],
            watching: [],
            following: [],
            follwers: [],
            commentDislike: [],
            commentLike: [],
            email: '',
            language: 'en_US',
            userName: _lst[index].userNsme,
            userId: _lst[index].userId,
            onlinePicPath: _lst[index].onlinePath),
        preventDuplicates: false);
  }
}
