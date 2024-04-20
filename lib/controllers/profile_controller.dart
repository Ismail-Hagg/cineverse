import 'dart:convert';
import 'dart:io';

import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/comments_page_controller.dart';
import 'package:cineverse/controllers/follow_controllere.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/model_exports.dart';
import 'package:cineverse/pages/chat/chat_page_controller.dart';
import 'package:cineverse/pages/comments_page/comments_page_View_controller.dart';
import 'package:cineverse/pages/follow_page/follow_view_controller.dart';
import 'package:cineverse/pages/settings_page/settings_view_controller.dart';
import 'package:cineverse/services/firebase_messaging_service.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  UserModel _model = UserModel();
  UserModel get model => _model;

  int _tab = 1;
  int get tab => _tab;

  bool _loading = false;
  bool get loading => _loading;

  bool _checkPic = false;
  bool get checkPic => _checkPic;

  bool _isMe = false;
  bool get isMe => _isMe;

  List<List<(MovieDetaleModel, EpisodeModeL)>> _lst = [];
  List<List<(MovieDetaleModel, EpisodeModeL)>> get lst => _lst;

  final List<CommentModel> _commentsList = [];
  List<CommentModel> get commentsList => _commentsList;

  int _commentCount = 0;
  int get commentCount => _commentCount;

  final Map<String, List<String>> _laterComments = {};
  Map<String, List<String>> get laterComments => _laterComments;

  @override
  void onInit() {
    super.onInit();

    _model = Get.arguments ?? Get.find<HomeController>().userModel;
    _isMe =
        _model.userId == Get.find<AuthController>().userModel.userId.toString();
    _lst = [
      <(MovieDetaleModel, EpisodeModeL)>[],
      <(MovieDetaleModel, EpisodeModeL)>[],
      <(MovieDetaleModel, EpisodeModeL)>[]
    ];
    getUserData();
    fireMovie(collection: FirebaseUserPaths.favorites);
    comments();
    checking(pic: _model.localPicPath.toString());
  }

  // check if the profile pic is in the phone
  void checking({required String pic}) async {
    await File(pic).exists().then((value) {
      _checkPic = value;
      update();
    });
  }

  // get user data
  void getUserData() async {
    await FirebaseServices()
        .getCurrentUser(userId: _model.userId.toString())
        .then((value) {
      _model = UserModel.fromMap(value.data() as Map<String, dynamic>);
      update();
    });
  }

  // nav to comments page
  void touchNav(
      {required int tab, required List<String> ids, required String title}) {
    switch (tab) {
      case 0:
        Get.create(() => CommentsPageController());
        Get.to(() => const CommentsPageViewController(),
            arguments: ProfileToComment(
                isMe: _isMe,
                user: _model,
                map: _laterComments,
                fromProfile: true),
            preventDuplicates: false);
        break;
      case 1 || 2:
        followNav(ids: ids, title: title);
      default:
    }
  }

  // change tabs
  void changeTabs({required int tab}) {
    if (tab != _tab) {
      _tab = tab;
      update();

      switch (_tab) {
        case 1:
          fireMovie(collection: FirebaseUserPaths.favorites);
          break;

        case 2:
          fireMovie(collection: FirebaseUserPaths.watchlist);
          break;

        case 3:
          fireMovie(collection: FirebaseUserPaths.keeping);
          break;
        default:
      }
    }
  }

  // back
  void goBack() {
    Get.back();
  }

  // go to settings or chat
  void settingChat({required bool isMe}) {
    isMe
        ? Get.to(() => const SettingsViewController())
        : Get.to(() => const ChatPageViewController(), arguments: _model);
  }

  // get comments
  void comments() async {
    await FirebaseServices()
        .userCollections(
            uid: _model.userId.toString(),
            collection: FirebaseUserPaths.comments.name,
            order: false)
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          _commentCount = value.docs.length;
          for (var i = 0; i < value.docs.length; i++) {
            try {
              _commentsList.add(
                CommentModel.fromMap(
                    value.docs[i].data() as Map<String, dynamic>),
              );
              commentLater(map: value.docs[i].data() as Map<String, dynamic>);
            } catch (e) {
              print('== error => $e');
            }
          }
          update();
        }
      },
    );
  }

  // set the latercommens object
  void commentLater({required Map<String, dynamic> map}) {
    String movieId = map['movieId'];
    String commentId = map['commentId'];

    if (_laterComments.containsKey(movieId)) {
      List<String> lstTemp = _laterComments[movieId] as List<String>;
      lstTemp.add(commentId);
      _laterComments[movieId] = lstTemp;
    } else {
      _laterComments[movieId] = [commentId];
    }
  }

  // get movies and shows from firebase
  void fireMovie({required FirebaseUserPaths collection}) async {
    if (_lst[_tab - 1].isEmpty) {
      _loading = true;
      update();
      await FirebaseServices()
          .userCollections(
              uid: _model.userId.toString(),
              collection: collection.name,
              order: false)
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
            for (var i = 0; i < value.docs.length; i++) {
              try {
                _lst[_tab - 1].add((
                  _tab == 3
                      ? MovieDetaleModel()
                      : MovieDetaleModel.fromMap(
                          value.docs[i].data() as Map<String, dynamic>,
                          fire: true),
                  _tab == 3
                      ? EpisodeModeL.fromMap(
                          value.docs[i].data() as Map<String, dynamic>, true)
                      : EpisodeModeL()
                ));
                _loading = false;
                update();
              } catch (e) {
                _loading = false;
                update();
              }
            }
          } else {
            _loading = false;
            update();
          }
        },
      );
    }
  }

  // following process controller
  void controllFollow() {
    UserModel myModel = Get.find<HomeController>().userModel;
    if (myModel.following!.contains(_model.userId.toString())) {
      unfollow(myModel: myModel);
    } else {
      follow(myModel: myModel);
    }
  }

  // following someone
  void follow({required UserModel myModel}) async {
    // update the one youre following object
    _model.follwers!.add(myModel.userId.toString());
    update();
    // update local opbeect and save it locally
    myModel.following!.add(_model.userId.toString());
    await DataPref().setUser(myModel).then(
      (value) async {
        // update both objects in firebase
        await pushPull(
                isMe: true,
                id: myModel.userId.toString(),
                otherId: _model.userId.toString(),
                add: true)
            .then(
          (_) async {
            await pushPull(
                    isMe: false,
                    id: _model.userId.toString(),
                    otherId: myModel.userId.toString(),
                    add: true)
                .then(
              (_) async {
                // subscribe to topic
                MessagingService().topicSub(userId: _model.userId.toString());
                // notify other person
                String commentBody =
                    _model.language.toString().substring(0, 2) == 'en'
                        ? 'Followed You'
                        : ' قام بمتابعتك';
                NotificationAction action = NotificationAction(
                    userName: myModel.userName.toString(),
                    userImage: myModel.onlinePicPath.toString(),
                    notificationBody: commentBody,
                    posterPath: myModel.onlinePicPath.toString(),
                    title: '',
                    isShow: true,
                    movieOverView: '',
                    type: NotificationType.followed,
                    userId: myModel.userId.toString(),
                    movieId: '');

                await MessagingService().sendMessage(
                  title: myModel.userName.toString(),
                  body: commentBody,
                  token: _model.messagingToken.toString(),
                  action: jsonEncode(
                    action.toMap(),
                  ),
                );

                await FirebaseServices().uploadNotification(
                    userId: _model.userId.toString(),
                    collection: FirebaseUserPaths.notifications.name,
                    action: action);

                await MessagingService().sendMessageTopic(
                    userId: myModel.userId.toString(),
                    otherId: _model.userId.toString(),
                    otherUserName: _model.userName.toString());
              },
            );
          },
        );
      },
    );
  }

  // unfollowing someone
  void unfollow({required UserModel myModel}) async {
    _model.follwers!.remove(myModel.userId.toString());
    update();
    myModel.following!.remove(_model.userId.toString());
    await DataPref().setUser(myModel).then(
      (value) async {
        await pushPull(
                id: myModel.userId.toString(),
                otherId: _model.userId.toString(),
                add: false,
                isMe: true)
            .then(
          (_) async {
            await pushPull(
                    isMe: false,
                    id: _model.userId.toString(),
                    otherId: myModel.userId.toString(),
                    add: false)
                .then(
              (_) async {
                MessagingService()
                    .topicUnSubscribe(userId: _model.userId.toString());
              },
            );
          },
        );
      },
    );
  }

  // get useer data before updating firebase
  Future<void> pushPull(
      {required String id,
      required String otherId,
      required bool add,
      required bool isMe}) async {
    await FirebaseServices().getCurrentUser(userId: id).then(
      (value) async {
        UserModel model =
            UserModel.fromMap(value.data() as Map<String, dynamic>);
        isMe
            ? add
                ? model.following!.add(otherId)
                : model.following!.remove(otherId)
            : add
                ? model.follwers!.add(otherId)
                : model.follwers!.remove(otherId);
        await FirebaseServices().userUpdate(userId: id, map: model.toMap());
      },
    );
  }

  // nav to following or followers page
  void followNav({required List<String> ids, required String title}) {
    Get.create(() => FollowController());
    Get.to(() => const FollowViewControll(),
        arguments: {'ids': ids, 'title': title}, preventDuplicates: false);
  }
}
