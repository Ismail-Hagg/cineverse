import 'dart:convert';

import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/controllers/profile_controller.dart';
import 'package:cineverse/models/comment_model.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/models/notification_action_model.dart';
import 'package:cineverse/models/profile_to_comment.dart';
import 'package:cineverse/models/result_details_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/profile_page/profile_controller.dart';
import 'package:cineverse/services/comment_movie_service.dart';
import 'package:cineverse/services/firebase_messaging_service.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CommentsPageController extends GetxController {
  final List<CommentModel> _commentsList = [];
  List<CommentModel> get commentList => _commentsList;

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  final bool _isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  late ProfileToComment _model;
  ProfileToComment get model => _model;

  bool _loading = false;
  bool get loading => _loading;

  String _replyToComment = '';
  String get replyToComment => _replyToComment;

  final List<(MovieDetaleModel, MovieDetaleModel, DateTime, int, int, String)>
      _choices = [];
  List<(MovieDetaleModel, MovieDetaleModel, DateTime, int, int, String)>
      get choices => _choices;

  final Map<String,
          (MovieDetaleModel, MovieDetaleModel, DateTime, int, int, String)>
      _tracking = {};

  @override
  void onInit() {
    super.onInit();
    first();
  }

  // start
  void first() async {
    _model = Get.arguments;
    if (_model.fromProfile == true) {
      _userModel = _model.user;
      getComments();
    } else {
      await FirebaseServices()
          .getCurrentUser(userId: _model.user.userId.toString())
          .then((value) {
        UserModel parsing =
            UserModel.fromMap(value.data() as Map<String, dynamic>);
        _model.user = parsing;
        _userModel = _model.user;
        _model.isMe = _model.user.userId.toString() ==
            Get.find<HomeController>().userModel.userId.toString();
        getComments();
      });
    }
  }

  // add a reply to comment
  void reply({
    required int index,
  }) async {
    if (_replyToComment.trim() != '') {
      CommentModel reply = CommentModel(
          commentId: const Uuid().v4(),
          userId: Get.find<HomeController>().userModel.userId.toString(),
          userName: Get.find<HomeController>().userModel.userName.toString(),
          userLink:
              Get.find<HomeController>().userModel.onlinePicPath.toString(),
          time: DateTime.now(),
          comment: _replyToComment.trim(),
          likes: 0,
          dislikea: 0,
          hasMore: false,
          token: Get.find<HomeController>().userModel.messagingToken.toString(),
          commentOpen: false,
          repliesNum: 0,
          movieId: _commentsList[index].movieId);
      _commentsList[index].hasMore == false
          ? _commentsList[index].hasMore = true
          : null;
      _commentsList[index].repliesNum = _commentsList[index].repliesNum + 1;
      _commentsList[index].subComments == null
          ? _commentsList[index].subComments = [reply]
          : _commentsList[index].subComments!.insert(0, reply);
      _commentsList[index].replyBox = false;
      _replyToComment = '';
      update();
      await FirebaseServices()
          .keepComment(
              path: FirebaseMainPaths.comments,
              movieId: _commentsList[index].movieId,
              state: CommentState.upload,
              commentId: _commentsList[index].commentId,
              repId: reply.commentId,
              map: reply.toMap(),
              reply: true)
          .then(
        (value) async {
          await FirebaseServices()
              .keepComment(
                  path: FirebaseMainPaths.comments,
                  movieId: _commentsList[index].movieId,
                  state: CommentState.update,
                  commentId: _commentsList[index].commentId,
                  map: _commentsList[index].toMap(),
                  reply: false)
              .then(
            (value) async {
              // notify comment owner
              if (_model.isMe == false) {
                await FirebaseServices()
                    .getCurrentUser(userId: _commentsList[index].userId)
                    .then(
                  (value) async {
                    UserModel user =
                        UserModel.fromMap(value.data() as Map<String, dynamic>);

                    String comment = _commentsList[index].comment;

                    String commentBody =
                        user.language.toString().substring(0, 2) == 'en'
                            ? 'Replied to Your Comment - $comment'
                            : ' قام بالرد على تعليقك - $comment';

                    String token = _commentsList[index].token;
                    UserModel myUserModel =
                        Get.find<HomeController>().userModel;

                    NotificationAction action = NotificationAction(
                        userName: myUserModel.userName.toString(),
                        userImage: myUserModel.onlinePicPath.toString(),
                        notificationBody: commentBody,
                        posterPath: _commentsList[index].userLink.toString(),
                        title: 'somr ttl',
                        isShow: false,
                        movieOverView: _commentsList[index].commentId,
                        type: NotificationType.comment,
                        userId: myUserModel.userId.toString(),
                        movieId: _commentsList[index].movieId);
                    sendNotification(
                        action: jsonEncode(action.toMap()),
                        token: token,
                        body: commentBody,
                        image: myUserModel.onlinePicPath.toString(),
                        title: myUserModel.userName.toString());
                    await FirebaseServices().uploadNotification(
                        userId: _commentsList[index].userId,
                        collection: FirebaseUserPaths.notifications.name,
                        action: action);
                  },
                );
              }
            },
          );
        },
      );
    }
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

  // show and hide replies
  void repFlip({required int index}) {
    _commentsList[index].showRep == true
        ? _commentsList[index].showRep = false
        : _commentsList[index].showRep = true;
    update();
  }

  // typing in reply box
  void replyChange({required String reply}) {
    _replyToComment = reply;
    update();
  }

  // toggle reply box
  void repBoxOpen({required int index}) {
    if (_commentsList[index].replyBox == false) {
      _commentsList[index].replyBox = true;
    } else {
      _commentsList[index].replyBox = false;
      _replyToComment = '';
    }
    update();
  }

  // nav to profile
  void profileNav({required int index, required int repIndex}) {
    CommentModel comment = _commentsList[index].subComments![repIndex];
    UserModel myModel = Get.find<HomeController>().userModel;
    UserModel otherModel = UserModel(
        userId: comment.userId,
        userName: comment.userName,
        following: [],
        follwers: [],
        onlinePicPath: comment.userLink);
    if (comment.userId != myModel.userId.toString()) {
      Get.create(() => ProfilePageController());
      Get.to(() => const ProfileViewController(), arguments: otherModel);
    }
  }

  // full comments
  void commentFull(
      {required int index, required bool reply, required int repIndex}) {
    reply
        ? _commentsList[index].subComments![repIndex].commentOpen =
            !_commentsList[index].subComments![repIndex].commentOpen
        : _commentsList[index].commentOpen = !_commentsList[index].commentOpen;
    update();
  }

  // get comments, bad algorithm , could be improved
  void getComments() {
    _loading = true;
    update();
    _model.map.forEach(
      (key, value) async {
        await FirebaseServices()
            .getOtherComments(movieId: key)
            .then((comment) async {
          if (comment.docs.isNotEmpty) {
            for (var i = 0; i < comment.docs.length; i++) {
              if (value.contains(comment.docs[i].id)) {
                CommentModel loopComment = CommentModel.fromMap(
                    comment.docs[i].data() as Map<String, dynamic>);

                await CommentMovieService()
                    .getHomeInfo(id: loopComment.movieId)
                    .then(
                  (value) async {
                    _choices.add(
                      (
                        value.$1,
                        value.$2,
                        loopComment.time,
                        loopComment.likes,
                        loopComment.repliesNum,
                        loopComment.comment
                      ),
                    );
                    _tracking[loopComment.movieId] = (
                      value.$1,
                      value.$2,
                      loopComment.time,
                      loopComment.likes,
                      loopComment.repliesNum,
                      loopComment.comment
                    );
                    _commentsList.add(
                      loopComment,
                    );
                    if (loopComment.hasMore == true) {
                      await FirebaseServices()
                          .keepComment(
                              path: FirebaseMainPaths.comments,
                              commentId: loopComment.commentId,
                              movieId: loopComment.movieId,
                              state: CommentState.read,
                              reply: true)
                          .then(
                        (reps) {
                          List<CommentModel> subs = [];
                          for (var x = 0; x < reps.$1!.docs.length; x++) {
                            subs.add(
                              CommentModel.fromMap(reps.$1!.docs[x].data()
                                  as Map<String, dynamic>),
                            );
                          }
                          loopComment.subComments = subs;
                        },
                      );
                    }
                  },
                );
              }
            }
          }
        }).then(
          (value) {
            _commentsList.sort((a, b) => b.time.compareTo(a.time));
            _choices.sort((a, b) => b.$3.compareTo(a.$3));
            _loading = false;
            update();
          },
        );
      },
    );
  }

  void movieNav({required MovieDetaleModel movie, required int index}) {
    Get.find<HomeController>().navToDetale(
      res: ResultsDetail(
          id: movie.id,
          isShow: movie.isShow,
          overview: movie.overview,
          posterPath: movie.posterPath,
          releaseDate: movie.releaseDate,
          title: movie.title,
          voteAverage: movie.voteAverage),
    );
  }

  // sort accordingly
  void sorting({required CommentOrder order}) {
    if (_isIos) {
      Get.back();
    }
    switch (order) {
      case CommentOrder.timeRecent:
        _commentsList.sort((a, b) => b.time.compareTo(a.time));
        _choices.sort((a, b) => b.$3.compareTo(a.$3));
        update();
        break;
      case CommentOrder.timeOld:
        _commentsList.sort((a, b) => a.time.compareTo(b.time));
        _choices.sort((a, b) => a.$3.compareTo(b.$3));
        update();
        break;
      case CommentOrder.replies:
        _commentsList.sort((a, b) => b.repliesNum.compareTo(a.repliesNum));
        _choices.sort((a, b) => b.$5.compareTo(a.$5));
        update();
        break;

      case CommentOrder.leastLikes:
        _commentsList.sort((a, b) => a.likes.compareTo(b.likes));
        _choices.sort((a, b) => a.$4.compareTo(b.$4));
        update();
        break;

      case CommentOrder.mostLikes:
        _commentsList.sort((a, b) => b.likes.compareTo(a.likes));
        _choices.sort((a, b) => b.$4.compareTo(a.$4));
        update();
        break;
      default:
    }
  }
}
