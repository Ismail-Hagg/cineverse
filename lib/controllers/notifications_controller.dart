import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/comments_page_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/controllers/profile_controller.dart';
import 'package:cineverse/models/notification_action_model.dart';
import 'package:cineverse/models/profile_to_comment.dart';
import 'package:cineverse/models/result_details_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/chat/chat_page_controller.dart';
import 'package:cineverse/pages/comments_page/comments_page_View_controller.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_controller.dart';
import 'package:cineverse/pages/profile_page/profile_controller.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsController extends GetxController {
  final bool isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  final List<NotificationAction> _notifications = [];
  List<NotificationAction> get notifications => _notifications;

  final Map<String, String> _ids = {};
  Map<String, String> get ids => _ids;

  bool _loading = false;
  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  // get notifications from backend
  void getNotifications() async {
    _loading = true;
    update();
    await FirebaseServices()
        .userCollections(
            uid: _userModel.userId.toString(),
            collection: FirebaseUserPaths.notifications.name,
            order: false)
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var i = 0; i < value.docs.length; i++) {
          NotificationAction action = NotificationAction.fromMap(
              value.docs[i].data() as Map<String, dynamic>);
          _notifications.add(action);
          _ids[action.time.toString()] = value.docs[i].id;
        }
        _notifications.sort((a, b) => b.time!.compareTo(a.time as DateTime));
      }
    });
    _loading = false;
    update();
  }

  // nav to prifile
  void profileNav(
      {required String userName,
      required String userId,
      required String link,
      required int index,
      required NotificationType type}) {
    if (type == NotificationType.chatMessage ||
        type == NotificationType.comment ||
        type == NotificationType.followed ||
        type == NotificationType.followerAction) {
      Get.create(() => ProfilePageController());
      Get.to((const ProfileViewController()),
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
              userName: userName,
              userId: userId,
              onlinePicPath: link),
          preventDuplicates: false);
    } else {
      NotificationAction action = _notifications[index];

      Get.find<HomeController>().navToDetale(
        res: ResultsDetail(
          releaseDate: 'Year'.tr,
          voteAverage: 0.0,
          isShow: true,
          overview: action.movieOverView,
          posterPath: action.posterPath,
          title: action.title,
          mediaType: 'tv',
          id: int.parse(
            action.movieId,
          ),
        ),
      );
    }
  }

  // do when clicked
  void clicked({required int index}) {
    NotificationAction action = _notifications[index];
    switch (action.type) {
      case NotificationType.releaseDate || NotificationType.showEnded:
        Get.find<HomeController>().navToDetale(
            res: ResultsDetail(
                id: int.parse(action.movieId),
                voteAverage: 0,
                backdropPath: '',
                overview: action.movieOverView.toString(),
                posterPath: imagebase + action.posterPath.toString(),
                releaseDate: '',
                title: action.title.toString(),
                isShow: action.isShow,
                mediaType: action.isShow ? 'tv' : 'movie'));
        break;
      case NotificationType.chatMessage:
        Get.to(() => const ChatPageViewController(),
            arguments:
                UserModel(userId: action.userId, userName: action.userName));
        break;

      case NotificationType.newEpisode:
        Get.to(
          () => const KeepingViewController(),
        );
        break;
      case NotificationType.comment:
        Get.create(() => CommentsPageController());
        Get.to(() => const CommentsPageViewController(),
            arguments: ProfileToComment(
                isMe: false,
                user: UserModel(
                    userId: action.userId,
                    commentLike: [],
                    commentDislike: [],
                    userName: action.userName),
                map: {
                  action.movieId: [action.movieOverView]
                },
                fromProfile: false),
            preventDuplicates: false);
        break;
      default:
    }
    notificationUpdate(index: index);
  }

  // mark all notifications as read
  void readAll() {
    Get.find<HomeController>().notifiyOff();
    bool track = false;
    if (isIos) {
      Get.back();
    }
    for (var i = 0; i < _notifications.length; i++) {
      if (_notifications[i].open == false) {
        track = true;
        notificationUpdate(index: i);
      }
    }
    print(track ? 'done with it' : 'nothing to read');
  }

  // update notification
  void notificationUpdate({required int index}) async {
    _notifications[index].open = true;
    update();
    await FirebaseServices().updateNotification(
        userId: _userModel.userId.toString(),
        collection: FirebaseUserPaths.notifications.name,
        id: _ids[_notifications[index].time.toString()].toString(),
        action: _notifications[index]);
  }
}
