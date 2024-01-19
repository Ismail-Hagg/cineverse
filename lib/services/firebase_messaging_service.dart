import 'dart:convert';

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
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class MessagingService extends GetxController {
  final FirebaseMessaging _messagingInstance = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  String _token = '';
  String get token => _token;

  // init the messaging and get the token
  Future<String> initMessaging() async {
    NotificationSettings settings =
        await _messagingInstance.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(
        handleBackgroundMessage,
      );
      FirebaseMessaging.onMessage.listen((message) {
        localNotificationInit(message);
        showNotification(message);
      });

      setupInteractMessage();

      await _messagingInstance.getToken().then(
        (value) {
          if (value != null) {
            _token = value;
          }
        },
      );
      return _token;
    } else {
      return '';
    }
  }

  // initilize the local notification plugin
  void localNotificationInit(RemoteMessage message) async {
    var androidSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    // do ios and mac later
    var initSettings = InitializationSettings(android: androidSettings);

    await _localNotification.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (payload) async {
        handleMessageClick(message);
      },
    );
  }

  // show notification on device
  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidChannel =
        const AndroidNotificationChannel('101', 'High',
            importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(androidChannel.id, androidChannel.name,
            channelDescription: 'description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    Future.delayed(
      Duration.zero,
      () {
        _localNotification.show(0, message.notification!.title.toString(),
            message.notification!.body.toString(), notificationDetails);
      },
    );
  }

  // interact with notification message
  Future<void> setupInteractMessage() async {
    RemoteMessage? initMessage = await _messagingInstance.getInitialMessage();

    if (initMessage != null) {
      // terminated
      handleMessageClick(initMessage);
    }

    // background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessageClick(event);
    });
  }

  void handleMessageClick(RemoteMessage message) {
    try {
      NotificationAction action =
          NotificationAction.fromMap(jsonDecode(message.data['action']));
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
                mediaType: action.isShow ? 'tv' : 'movie'),
          );
          break;
        case NotificationType.chatMessage:
          Get.to(() => const ChatPageViewController(),
              arguments:
                  UserModel(userId: action.userId, userName: action.userName));
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

        case NotificationType.followed:
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
                  userName: action.userName,
                  userId: action.userId,
                  onlinePicPath: action.userImage),
              preventDuplicates: false);
          break;

        case NotificationType.followerAction:
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
                  userName: action.movieOverView,
                  userId: action.movieId,
                  onlinePicPath: action.userImage),
              preventDuplicates: false);
          break;
        default:
      }
    } catch (e) {
      print('===>> $e');
    }
  }

  // send message
  Future<bool> sendMessage(
      {required String title,
      required String body,
      required String token,
      required String action,
      String? image}) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('targetMessage');
    try {
      final response = await callable.call(<String, dynamic>{
        'title': title,
        'body': body,
        'token': token,
        'image': image,
        'action': action
      });

      return response.data == null ? false : true;
    } catch (e) {
      return false;
    }
  }

  // send message to topic
  Future<bool> sendMessageTopic(
      {required String userId,
      required String otherId,
      required String otherUserName,
      String? image}) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('topicMessage');
    try {
      final response = await callable.call(<String, dynamic>{
        'userId': userId,
        'otherId': otherId,
        'otherUserName': otherUserName,
        'image': image,
      });

      return response.data == null ? false : true;
    } catch (e) {
      return false;
    }
  }

  // subscribe to topic
  void topicSub({required String userId}) async {
    await _messagingInstance.subscribeToTopic(userId);
  }

  // unsubscribe from topic
  void topicUnSubscribe({required String userId}) async {
    await _messagingInstance.unsubscribeFromTopic(userId);
  }
}

// handle background messages
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
}
