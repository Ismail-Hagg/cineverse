import 'dart:io';

import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/comments_page_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/comment_model.dart';
import 'package:cineverse/models/episode_omdel.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/models/profile_to_comment.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/chat/chat_page_controller.dart';
import 'package:cineverse/pages/comments_page/comments_page_View_controller.dart';
import 'package:cineverse/pages/settings_page/settings_view_controller.dart';
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
    if (Get.arguments != null) {
      await FirebaseServices()
          .getCurrentUser(userId: _model.userId.toString())
          .then((value) {
        _model = UserModel.fromMap(value.data() as Map<String, dynamic>);
        update();
      });
    }
  }

  // nav to comments page
  void touchNav({required int tab}) {
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
      follow();
    } else {
      unfollow();
    }
  }

  // following someone
  void follow() {
    // update the one youre following object

    // update local opbeect and save it locally

    // update both objects in firebase

    // subscribe to topic

    // notify other person
  }

  // unfollowing someone
  void unfollow() {}
}
