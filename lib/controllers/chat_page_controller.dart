import 'dart:convert';

import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/chat_message_model.dart';
import 'package:cineverse/models/notification_action_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/firebase_messaging_service.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class ChatPageController extends GetxController {
  final bool _isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  bool get isIos => _isIos;
  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  UserModel _otherUser = UserModel();
  UserModel? get otherUser => _otherUser;

  late Stream<QuerySnapshot> _chatStream;
  Stream<QuerySnapshot> get straem => _chatStream;

  List<types.Message> _messages = [];
  List<types.Message> get messages => _messages;

  late types.User _user;
  types.User get user => _user;

  List<Map<String, dynamic>> _dino = [];
  List<Map<String, dynamic>> get dino => _dino;

  @override
  void onInit() {
    super.onInit();

    _otherUser = Get.arguments;
    getUserDate();
    _chatStream = FirebaseServices().getUserChat(
        userId: _userModel.userId.toString(),
        otherId: _otherUser.userId.toString());
    _user = types.User(id: _userModel.userId.toString());
  }

  @override
  void onClose() {
    super.onClose();
    changeData(userId: _userModel.userId.toString(), data: '');
  }

  // change user data
  void changeData({
    required String userId,
    required String data,
  }) async {
    await FirebaseServices()
        .userUpdate(userId: userId, map: {'openChat': data});
  }

  // get the other user
  void getUserDate() async {
    await FirebaseServices()
        .getCurrentUser(userId: _otherUser.userId.toString())
        .then((value) {
      _otherUser = UserModel.fromMap(value.data() as Map<String, dynamic>);
    });
  }

  // get messages from firebase
  void getMessages(List<dynamic> lst) {
    _messages = [];
    _dino = [];
    for (var i = 0; i < lst.length; i++) {
      _messages.insert(0, types.TextMessage.fromJson(lst[i]));
      _dino.add(lst[i]);
    }
    update();
  }

  // clear the isupdated flag
  void clearIsUpdated() async {
    await FirebaseServices()
        .clearIsUpdates(
            userId: _userModel.userId.toString(),
            chatId: _otherUser.userId.toString())
        .then((_) {
      changeData(
          userId: _userModel.userId.toString(),
          data: _otherUser.userId.toString());
    });
  }

  // alert comment owner
  void sendNotification(
      {required String token,
      required String title,
      required String body,
      required String action,
      String? image}) async {
    await MessagingService().sendMessage(
        title: title, body: body, token: token, image: image, action: action);
  }

  // send message
  void sendMessage(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    dino.add(textMessage.toJson());

    await FirebaseServices()
        .sendMessage(
            model: ChatMessageModel(
                userId: _userModel.userId.toString(),
                otherId: _otherUser.userId.toString(),
                isPicOnline: _otherUser.onlinePicPath != '' ? true : false,
                change: Timestamp.now(),
                messages: dino,
                onlinePath: _otherUser.onlinePicPath.toString(),
                userNsme: _otherUser.userName.toString(),
                token: _otherUser.messagingToken.toString(),
                ref: FirebaseServices()
                    .ref
                    .doc(_otherUser.userId)
                    .collection(FirebaseUserPaths.chat.name)
                    .doc(_userModel.userId.toString()),
                isUpdated: false))
        .then((_) async {
      await FirebaseServices().sendMessage(
          model: ChatMessageModel(
              userId: _otherUser.userId.toString(),
              otherId: _userModel.userId.toString(),
              isPicOnline: _userModel.onlinePicPath != '' ? true : false,
              change: Timestamp.now(),
              messages: dino,
              onlinePath: _userModel.onlinePicPath.toString(),
              userNsme: _userModel.userName.toString(),
              token: _userModel.messagingToken.toString(),
              ref: FirebaseServices()
                  .ref
                  .doc(_userModel.userId)
                  .collection(FirebaseUserPaths.chat.name)
                  .doc(_otherUser.userId.toString()),
              isUpdated: true));
    }).then(
      (_) async {
        await FirebaseServices()
            .getCurrentUser(userId: _otherUser.userId.toString())
            .then(
          (value) async {
            if ((value.data() as Map<String, dynamic>)['openChat'] !=
                _userModel.userId.toString()) {
              _otherUser =
                  UserModel.fromMap(value.data() as Map<String, dynamic>);

              String commentBody =
                  _otherUser.language.toString().substring(0, 2) == 'en'
                      ? 'Sent You a Message - ${message.text}'
                      : ' ارسل لك رسالة - ${message.text}';

              NotificationAction action = NotificationAction(
                  userName: _userModel.userName.toString(),
                  userImage: _userModel.onlinePicPath.toString(),
                  notificationBody: commentBody,
                  posterPath: '',
                  title: '',
                  isShow: true,
                  movieOverView: '',
                  type: NotificationType.chatMessage,
                  userId: _userModel.userId.toString(),
                  movieId: '');

              sendNotification(
                  action: jsonEncode(action.toMap()),
                  token: _otherUser.messagingToken.toString(),
                  body: commentBody,
                  image: _userModel.onlinePicPath.toString(),
                  title: _userModel.userName.toString());

              await FirebaseServices().uploadNotification(
                  userId: _otherUser.userId.toString(),
                  collection: FirebaseUserPaths.notifications.name,
                  action: action);
            }
          },
        );
      },
    );
  }
}
