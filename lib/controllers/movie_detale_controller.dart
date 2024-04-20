import 'dart:convert';

import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/profile_controller.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/model_exports.dart';
import 'package:cineverse/pages/profile_page/profile_controller.dart';
import 'package:cineverse/services/cast_service.dart';
import 'package:cineverse/services/collection_service.dart';
import 'package:cineverse/services/episode_service.dart';
import 'package:cineverse/services/firebase_messaging_service.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/services/image_service.dart';
import 'package:cineverse/services/movie_detale_service.dart';
import 'package:cineverse/services/recommendation_service.dart';
import 'package:cineverse/services/season_service.dart';
import 'package:cineverse/services/trailer_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class MovieDetaleController extends GetxController
    with GetSingleTickerProviderStateMixin {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;
  late MovieDetaleModel _detales;
  MovieDetaleModel get detales => _detales;

  final AuthController _authController = Get.find<AuthController>();
  AuthController get authController => _authController;

  ImagesModel _imageModel = ImagesModel();
  ImagesModel get imageModel => _imageModel;

  final bool _isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  int _loading = 0;
  int get loading => _loading;

  int _commentLoading = 0;
  int get commentLoading => _commentLoading;

  int _loadingSeason = 0;
  int get loadingSeason => _loadingSeason;

  int _imagesCounter = 0;
  int get imagesCounter => _imagesCounter;

  int _tabs = 1;
  int get tabs => _tabs;

  int _seasonTrack = 1;
  int get seasonTrack => _seasonTrack;

  bool _storyOpen = false;
  bool get storyOpen => _storyOpen;

  bool _isAscending = true;
  bool get isAscending => _isAscending;

  late AnimationController _controller;
  AnimationController get controller => _controller;

  TrailerModel _episodeModel = TrailerModel(
    isError: true,
  );
  TrailerModel get episodeModel => _episodeModel;

  final FocusNode _focusNode = FocusNode();
  FocusNode get focusNode => _focusNode;

  final TextEditingController _commentController = TextEditingController();
  TextEditingController get commentController => _commentController;

  bool _commentSelected = false;
  bool get commentSelected => _commentSelected;

  bool _commentOpen = false;
  bool get commentOpen => _commentOpen;

  final List<CommentModel> _commentList = [];
  List<CommentModel> get commentList => _commentList;

  String _replyToComment = '';
  String get replyToComment => _replyToComment;

  @override
  void onInit() {
    super.onInit();
    _userModel = _authController.userModel;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _detales = Get.arguments ?? MovieDetaleModel(isError: true);
    isCommentSelected();
    getData(res: _detales);
  }

  @override
  void onClose() {
    super.onClose();
    _controller.dispose();
    _commentController.dispose();
    _focusNode.dispose();
  }

  // delete comment
  void commentDelete(
      {required BuildContext context,
      required int index,
      required bool reply,
      required int repIndex,
      required bool isIos}) {
    platforMulti(
        isIos: isIos,
        title: reply ? 'repdel'.tr : "commentdel".tr,
        buttonTitle: ['cancel'.tr, "answer".tr],
        body: '',
        func: [
          () {
            Get.back();
          },
          () => reply
              ? replyDelete(commentIndex: index, replyIndex: repIndex)
              : deleteComment(index: index)
        ],
        context: context);
  }

  // delete reply
  void replyDelete({required int commentIndex, required int replyIndex}) async {
    Get.back();
    String commentid = _commentList[commentIndex].commentId;
    String replyid =
        _commentList[commentIndex].subComments![replyIndex].commentId;
    _commentList[commentIndex]
        .subComments!
        .remove(_commentList[commentIndex].subComments![replyIndex]);
    _commentList[commentIndex].repliesNum =
        _commentList[commentIndex].repliesNum - 1;
    if (_commentList[commentIndex].subComments!.isEmpty) {
      _commentList[commentIndex].subComments = null;
      _commentList[commentIndex].hasMore = false;
    }
    update();
    await FirebaseServices()
        .keepComment(
            path: FirebaseMainPaths.comments,
            movieId: _detales.id.toString(),
            state: CommentState.delete,
            commentId: commentid,
            reply: true,
            repId: replyid)
        .then(
      (value) async {
        await FirebaseServices().keepComment(
            path: FirebaseMainPaths.comments,
            movieId: _detales.id.toString(),
            state: CommentState.update,
            commentId: _commentList[commentIndex].commentId,
            map: _commentList[commentIndex].toMap(),
            reply: false);
      },
    );
  }

  // toggle reply box
  void repBoxOpen({required int index}) {
    if (_commentList[index].replyBox == false) {
      _commentList[index].replyBox = true;
    } else {
      _commentList[index].replyBox = false;
      _replyToComment = '';
    }
    update();
  }

  // delete comment
  void deleteComment({required int index}) async {
    Get.back();
    CommentModel comment = _commentList[index];
    _commentList.remove(comment);
    update();
    await FirebaseServices()
        .keepComment(
            path: FirebaseMainPaths.comments,
            movieId: _detales.id.toString(),
            state: CommentState.delete,
            commentId: comment.commentId,
            reply: false)
        .then(
      (value) async {
        await FirebaseServices().watchFav(
            userId: comment.userId,
            path: FirebaseUserPaths.comments,
            comment: comment,
            model: MovieDetaleModel(),
            upload: false);
      },
    );
  }

  // add a reply to comment
  void reply({
    required int index,
  }) async {
    if (_replyToComment.trim() != '') {
      CommentModel reply = CommentModel(
          commentId: const Uuid().v4(),
          userId: _userModel.userId.toString(),
          userName: _userModel.userName.toString(),
          userLink: _userModel.onlinePicPath.toString(),
          time: DateTime.now(),
          comment: _replyToComment.trim(),
          likes: 0,
          dislikea: 0,
          hasMore: false,
          token: _userModel.messagingToken.toString(),
          commentOpen: commentOpen,
          repliesNum: 0,
          movieId: _detales.id.toString());
      if (_commentList[index].hasMore == false) {
        _commentList[index].hasMore = true;
      }
      _commentList[index].repliesNum = _commentList[index].repliesNum + 1;
      _commentList[index].subComments == null
          ? _commentList[index].subComments = [reply]
          : _commentList[index].subComments!.insert(0, reply);
      _commentList[index].replyBox = false;
      _replyToComment = '';
      update();
      await FirebaseServices()
          .keepComment(
              path: FirebaseMainPaths.comments,
              movieId: _detales.id.toString(),
              state: CommentState.upload,
              commentId: _commentList[index].commentId,
              repId: reply.commentId,
              map: reply.toMap(),
              reply: true)
          .then(
        (value) async {
          await FirebaseServices()
              .keepComment(
                  path: FirebaseMainPaths.comments,
                  movieId: _detales.id.toString(),
                  state: CommentState.update,
                  commentId: _commentList[index].commentId,
                  map: _commentList[index].toMap(),
                  reply: false)
              .then(
            (value) async {
              // notify comment owner
              if (_commentList[index].userId != _userModel.userId.toString()) {
                await FirebaseServices()
                    .getCurrentUser(userId: _commentList[index].userId)
                    .then((value) async {
                  UserModel user =
                      UserModel.fromMap(value.data() as Map<String, dynamic>);

                  String comment = _commentList[index].comment;

                  String commentBody =
                      user.language.toString().substring(0, 2) == 'en'
                          ? 'Replied to Your Comment - $comment'
                          : ' قام بالرد على تعليقك - $comment';

                  String token = _commentList[index].token;

                  NotificationAction action = NotificationAction(
                      userName: _userModel.userName.toString(),
                      userImage: _userModel.onlinePicPath.toString(),
                      notificationBody: commentBody,
                      posterPath: _detales.posterPath.toString(),
                      title: _detales.title.toString(),
                      isShow: _detales.isShow as bool,
                      movieOverView: _detales.overview.toString(),
                      type: NotificationType.comment,
                      userId: _userModel.userId.toString(),
                      movieId: _detales.id.toString());
                  sendNotification(
                      action: jsonEncode(action.toMap()),
                      token: token,
                      body: commentBody,
                      image: _userModel.onlinePicPath.toString(),
                      title: _userModel.userName.toString());
                  await FirebaseServices().uploadNotification(
                      userId: _commentList[index].userId,
                      collection: FirebaseUserPaths.notifications.name,
                      action: action);
                });
              }
            },
          );
        },
      );
    }
  }

  // like controller
  void likeController(
      {required bool like,
      required int index,
      required bool reply,
      required int repIndex}) {
    String id = reply
        ? _commentList[index].subComments![repIndex].commentId
        : _commentList[index].commentId;
    if (like) {
      likeOp(
          add: !_userModel.commentLike!.contains(id),
          id: id,
          index: index,
          reply: reply,
          repIndex: repIndex);
      if (userModel.commentDislike!.contains(id)) {
        disLikeOp(
            add: false, id: id, index: index, reply: reply, repIndex: repIndex);
      }
    } else {
      disLikeOp(
          add: !_userModel.commentDislike!.contains(id),
          id: id,
          index: index,
          reply: reply,
          repIndex: repIndex);
      if (userModel.commentLike!.contains(id)) {
        likeOp(
            add: false, id: id, index: index, reply: reply, repIndex: repIndex);
      }
    }
    update();
    afterLike(index: index, reply: reply, repIndex: repIndex, like: like);
  }

  // add or remove a like
  void likeOp(
      {required bool add,
      required String id,
      required int index,
      required int repIndex,
      required bool reply}) {
    if (add) {
      _userModel.commentLike!.add(id);
      reply
          ? _commentList[index].subComments![repIndex].likes =
              _commentList[index].subComments![repIndex].likes + 1
          : _commentList[index].likes = _commentList[index].likes + 1;
    } else {
      _userModel.commentLike!.remove(id);
      reply
          ? _commentList[index].subComments![repIndex].likes =
              _commentList[index].subComments![repIndex].likes - 1
          : _commentList[index].likes = _commentList[index].likes - 1;
    }
  }

  // add or remove a dislike
  void disLikeOp(
      {required bool add,
      required String id,
      required int index,
      required int repIndex,
      required bool reply}) {
    if (add) {
      _userModel.commentDislike!.add(id);
      reply
          ? _commentList[index].subComments![repIndex].dislikea =
              _commentList[index].subComments![repIndex].dislikea + 1
          : _commentList[index].dislikea = _commentList[index].dislikea + 1;
    } else {
      _userModel.commentDislike!.remove(id);
      reply
          ? _commentList[index].subComments![repIndex].dislikea =
              _commentList[index].subComments![repIndex].dislikea - 1
          : _commentList[index].dislikea = _commentList[index].dislikea - 1;
    }
  }

  // after like
  void afterLike(
      {required int index,
      required bool reply,
      required int repIndex,
      required bool like}) async {
    await DataPref().setUser(_userModel).then(
      (value) async {
        if (value) {
          await FirebaseServices()
              .userUpdate(
                  userId: _userModel.userId.toString(), map: _userModel.toMap())
              .then(
            (value) async {
              await FirebaseServices()
                  .keepComment(
                      path: FirebaseMainPaths.comments,
                      movieId: _detales.id.toString(),
                      state: CommentState.update,
                      commentId: _commentList[index].commentId,
                      map: reply
                          ? _commentList[index].subComments![repIndex].toMap()
                          : _commentList[index].toMap(),
                      repId: reply
                          ? _commentList[index].subComments![repIndex].commentId
                          : '',
                      reply: reply)
                  .then(
                (value) async {
                  String id = reply
                      ? _commentList[index].subComments![repIndex].commentId
                      : _commentList[index].commentId;
                  if ((like && _userModel.commentLike!.contains(id)) ||
                      (like == false &&
                          _userModel.commentDislike!.contains(id))) {
                    String userIdGetInfo = reply
                        ? _commentList[index].subComments![repIndex].userId
                        : _commentList[index].userId;

                    String token = reply
                        ? _commentList[index].subComments![repIndex].token
                        : _commentList[index].token;

                    String comment = reply
                        ? _commentList[index].subComments![repIndex].comment
                        : _commentList[index].comment;
                    if (userIdGetInfo != _userModel.userId.toString()) {
                      await FirebaseServices()
                          .getCurrentUser(userId: userIdGetInfo)
                          .then((value) async {
                        UserModel user = UserModel.fromMap(
                            value.data() as Map<String, dynamic>);

                        String commentBody =
                            user.language.toString().substring(0, 2) == 'en'
                                ? like
                                    ? reply
                                        ? 'Liked Your Reply - $comment'
                                        : 'Liked Your Comment - $comment'
                                    : reply
                                        ? 'Disliked Your Reply - $comment'
                                        : 'Disliked Your Comment - $comment'
                                : like
                                    ? reply
                                        ? 'اعجب بردك - $comment'
                                        : 'اعجب بتعليقك - $comment'
                                    : reply
                                        ? 'لم يعجبه ردك - $comment'
                                        : 'لم يعجبه تعليقك - $comment';
                        NotificationAction action = NotificationAction(
                            userName: _userModel.userName.toString(),
                            userImage: _userModel.onlinePicPath.toString(),
                            notificationBody: commentBody,
                            posterPath: _detales.posterPath.toString(),
                            title: _detales.title.toString(),
                            isShow: _detales.isShow as bool,
                            movieOverView: _detales.overview.toString(),
                            type: NotificationType.comment,
                            userId: _userModel.userId.toString(),
                            movieId: _detales.id.toString());
                        sendNotification(
                            action: jsonEncode(action.toMap()),
                            token: token,
                            body: commentBody,
                            image: _userModel.onlinePicPath.toString(),
                            title: _userModel.userName.toString());
                        await FirebaseServices().uploadNotification(
                            userId: userIdGetInfo,
                            collection: FirebaseUserPaths.notifications.name,
                            action: action);
                      });
                    }
                  }
                  if (reply == false) {
                    await FirebaseServices().watchFav(
                        userId: _commentList[index].userId,
                        path: FirebaseUserPaths.comments,
                        model: MovieDetaleModel(),
                        upload: false,
                        update: true,
                        comment: _commentList[index]);
                  }
                },
              );
            },
          );
        } else {
          // data wasn't saved locally
        }
      },
    );
  }

  // upload comment
  void commentUpload({required bool reply, String? repid}) async {
    if (_commentController.text.trim() != '' && _commentLoading == 0) {
      String comment = _commentController.text.trim();
      _focusNode.unfocus();
      _commentController.clear();
      String commentId = const Uuid().v4();
      // build comment object
      CommentModel model = CommentModel(
        replyBox: false,
        showRep: false,
        commentId: commentId,
        userId: _userModel.userId.toString(),
        userName: _userModel.userName.toString(),
        userLink: _userModel.onlinePicPath.toString(),
        time: DateTime.now(),
        comment: comment,
        likes: 0,
        dislikea: 0,
        hasMore: false,
        token: _userModel.messagingToken.toString(),
        commentOpen: false,
        repliesNum: 0,
        movieId: _detales.id.toString(),
      );
      // add to the list
      commentList.insert(0, model);
      _commentOpen = false;
      update();
      // upload to firebase
      await FirebaseServices()
          .keepComment(
              repId: repid,
              reply: reply,
              commentId: commentId,
              map: model.toMap(),
              path: FirebaseMainPaths.comments,
              movieId: _detales.id.toString(),
              state: CommentState.upload)
          .then(
        (value) async {
          await FirebaseServices()
              .watchFav(
                  userId: _userModel.userId.toString(),
                  path: FirebaseUserPaths.comments,
                  model: MovieDetaleModel(),
                  upload: true,
                  comment: model)
              .then((value) => null);
        },
      );
    }
  }

  // get comments from firebase
  void getComments() async {
    await FirebaseServices()
        .keepComment(
            reply: false,
            path: FirebaseMainPaths.comments,
            movieId: _detales.id.toString(),
            state: CommentState.read)
        .then(
      (val) async {
        if (val.$1!.docs.isNotEmpty) {
          for (var i = 0; i < val.$1!.docs.length; i++) {
            _commentList.add(
              CommentModel.fromMap(
                  val.$1!.docs[i].data() as Map<String, dynamic>),
            );
            if ((val.$1!.docs[i].data() as Map<String, dynamic>)['hasMore'] ==
                true) {
              await FirebaseServices()
                  .keepComment(
                      path: FirebaseMainPaths.comments,
                      movieId: _detales.id.toString(),
                      state: CommentState.read,
                      commentId: val.$1!.docs[i].id,
                      reply: true)
                  .then(
                (value) {
                  List<CommentModel> subs = [];
                  for (var i = 0; i < value.$1!.docs.length; i++) {
                    subs.add(CommentModel.fromMap(
                        value.$1!.docs[i].data() as Map<String, dynamic>));
                  }
                  _commentList[(_commentList.length) - 1].subComments = subs;
                },
              );
            }
          }
        }
        _commentList.sort((a, b) => b.time.compareTo(a.time));
        _commentLoading = 0;
        for (var i = 0; i < _commentList.length; i++) {
          if (_commentList[i].subComments != null) {
            _commentList[i]
                .subComments!
                .sort((a, b) => b.time.compareTo(a.time));
          }
        }
        update();
      },
    );
  }

  // comment flip
  void commentFlip() {
    _commentOpen = !_commentOpen;
    update();
  }

  // full comments
  void commentFull(
      {required int index, required bool reply, required int repIndex}) {
    reply
        ? _commentList[index].subComments![repIndex].commentOpen =
            !_commentList[index].subComments![repIndex].commentOpen
        : _commentList[index].commentOpen = !_commentList[index].commentOpen;
    update();
  }

  // nav to profile from comment
  void navToProfile(
      {required int index, required bool reply, required int repIndex}) {
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
            userName: reply
                ? _commentList[index].subComments![repIndex].userName
                : _commentList[index].userName,
            userId: reply
                ? commentList[index].subComments![repIndex].userId
                : _commentList[index].userId,
            onlinePicPath: reply
                ? commentList[index].subComments![repIndex].userLink
                : _commentList[index].userLink),
        preventDuplicates: false);
  }

  // show and hide replies
  void repFlip({required int index}) {
    _commentList[index].showRep == true
        ? _commentList[index].showRep = false
        : _commentList[index].showRep = true;
    update();
  }

  // comments input selected or not
  void isCommentSelected() {
    _focusNode.addListener(
      () {
        if (_focusNode.hasFocus) {
          _commentSelected = true;
          update();
        } else {
          _commentSelected = false;
          update();
        }
      },
    );
  }

  // typing in reply box
  void replyChange({required String reply}) {
    _replyToComment = reply;
    update();
  }

  // get data from api
  void getData({required MovieDetaleModel res}) async {
    _loading = 1;
    _commentLoading = 1;
    update();
    var lan = _userModel.language.toString().replaceAll('_', '-');
    var show = res.isShow == true ? 'tv' : 'movie';
    var base = 'https://api.themoviedb.org/3/$show/${res.id}';
    var end = '?api_key=$apiKey&language=$lan';
    List<String> slashes = [
      '',
      '/credits',
      '/recommendations',
      '/videos',
      '/season',
      'https://api.themoviedb.org/3/collection/'
    ];

    for (var i = 0; i < slashes.length; i++) {
      switch (i) {
        case 0:
          await MovieDetaleService()
              .getHomeInfo(link: '$base${slashes[i]}$end')
              .then((value) {
            if (value.isError == false) {
              _detales = value;
            }
            _detales.isError = value.isError;
          });
          break;
        case 1:
          await CastService()
              .getHomeInfo(link: '$base/${slashes[i]}$end')
              .then((value) => {_detales.cast = value});
          break;
        case 2:
          await RecommendationService()
              .getHomeInfo(link: '$base/${slashes[i]}$end')
              .then(
                (value) => {
                  _detales.recomendation = value,
                },
              );
          break;
        case 3:
          await TrailerService()
              .getHomeInfo(link: '$base/${slashes[i]}$end')
              .then(
                (value) => {_detales.trailer = value},
              );
          break;
        case 4:
          if (res.isShow == true) {
            await SeasonService()
                .getHomeInfo(link: '$base/${slashes[i]}/1$end')
                .then((value) => {_detales.seaosn = value});
          }
          break;

        case 5:
          if (_detales.collectionId != '') {
            await CollectionService()
                .getHomeInfo(
                    link: slashes[5] + _detales.collectionId.toString() + end)
                .then((value) {
              _detales.collection = value;
            });
          }
          break;
      }
    }
    getComments();
    _loading = 0;
    update();
  }

  // change show season
  void seasonChange({required int season, required int index}) async {
    authController.platform == TargetPlatform.iOS ? Get.back() : null;
    if (_detales.seaosn!.seasonNumber != index) {
      _loadingSeason = 1;
      _seasonTrack = index;
      update();
      await SeasonService()
          .getHomeInfo(
              link:
                  'https://api.themoviedb.org/3/tv/${_detales.id}/season/$season?api_key=$apiKey&language=${_userModel.language.toString().replaceAll('_', '-')}')
          .then((value) {
        _detales.seaosn = value;
        _loadingSeason = 0;
        update();
      });
    }
  }

  // sort episode list ascending and descending
  void episodeSort({required bool ascending}) {
    if (ascending != _isAscending && _loading == 0 && _loadingSeason == 0) {
      if (ascending) {
        _detales.seaosn!.episodes!
            .sort((a, b) => a.episodeNumber.compareTo(b.episodeNumber));
        _isAscending = true;
      } else {
        _detales.seaosn!.episodes!
            .sort((b, a) => a.episodeNumber.compareTo(b.episodeNumber));
        _isAscending = false;
      }
      update();
    }
  }

  void load() {
    if (_loading == 1) {
      _loading = 0;
    } else {
      _loading = 1;
    }
    update();
  }

  // open and close story
  void storyFlip({required bool over}) {
    if (over) {
      _storyOpen = !_storyOpen;
      animationControll();
      update();
    }
  }

  // animation controll
  void animationControll() {
    if (_storyOpen) {
      _controller.forward();
    } else {
      controller.reverse();
    }
  }

  // change tabs
  void tabChange({required int tab}) {
    if (tab != _tabs) {
      _tabs = tab;
      update();
    }
  }

  // call api to get images
  void getImages(
      {required double height,
      required double width,
      required bool isActor,
      required String id,
      required Widget content,
      required bool isIos}) async {
    if (_loading == 0) {
      _imageModel = ImagesModel();
      _imagesCounter = 1;
      update();
      Get.dialog(content);
      ImagesService()
          .getImages(
              media: isActor
                  ? 'person'
                  : _detales.isShow == true
                      ? 'tv'
                      : 'movie',
              id: id,
              lang: _userModel.language
                  .toString()
                  .substring(0, _userModel.language.toString().indexOf('_')))
          .then((val) {
        _imageModel = val;
        _imagesCounter = 0;
        update();
      });
    }
  }

  // // trailer button pressed
  void trailerButton(
      {required Widget content,
      required BuildContext context,
      required TrailerModel? model}) {
    if (_loading == 0 && model!.isError == false) {
      if (model.results!.isEmpty) {
        platforMulti(
          isIos: _isIos,
          title: 'trailer'.tr,
          buttonTitle: ["ok".tr],
          func: [
            () {
              Get.back();
            }
          ],
          context: context,
        );
      } else if (model.results!.length == 1) {
        launcherUse(
            url: 'https://www.youtube.com/watch?v=${model.results![0].key}',
            context: context);
      } else {
        Get.dialog(content);
      }
    }
  }

  // use uri launcher
  void launcherUse({required String url, required BuildContext context}) async {
    await launcherUrl(url: url).then((value) async {
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
    });
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

  // upload favorites and or watchlist to firebase
  void watchFav({required FirebaseUserPaths path, required bool upload}) async {
    await FirebaseServices()
        .watchFav(
            userId: _userModel.userId.toString(),
            path: path,
            model: _detales,
            upload: upload)
        .then((_) {
      _authController.userUpdate(
          userId: _userModel.userId.toString(), map: _userModel.toMap());
    }).onError((error, stackTrace) {});
  }

  // when favorites or watchlist button clicked
  void favWatch(
      {required FirebaseUserPaths path,
      required String id,
      required BuildContext context}) async {
    if (_loading == 0 && _detales.isError == false) {
      switch (path) {
        case FirebaseUserPaths.favorites:
          if (_userModel.favs!.contains(id)) {
            _userModel.favs!.remove(id);
            update();
            _authController.saveUserDataLocally(model: _userModel).then(
              (value) {
                watchFav(path: path, upload: false);
              },
            ).onError(
              (error, stackTrace) {
                _userModel.favs!.add(id);
                update();
                platforMulti(
                  isIos: _isIos,
                  title: 'error'.tr,
                  buttonTitle: ["ok".tr],
                  body: error.toString(),
                  func: [
                    () {
                      Get.back();
                    }
                  ],
                  context: context,
                );
              },
            );
          } else {
            _userModel.favs!.add(id);
            update();
            _authController.saveUserDataLocally(model: _userModel).then(
              (value) {
                _detales.timestamp = Timestamp.now();
                watchFav(path: path, upload: true);
              },
            ).catchError((error, stackTrace) {
              _userModel.favs!.remove(id);
              update();
              platforMulti(
                isIos: _isIos,
                title: 'error'.tr,
                buttonTitle: ["ok".tr],
                body: error.toString(),
                func: [
                  () {
                    Get.back();
                  }
                ],
                context: context,
              );
            });
          }
          break;
        case FirebaseUserPaths.watchlist:
          bool contain = _detales.isShow == true
              ? _userModel.showWatchList!.contains(id)
              : _userModel.movieWatchList!.contains(id);
          if (contain) {
            platforMulti(
              isIos: _isIos,
              title: 'watchalready'.tr,
              buttonTitle: ["ok".tr],
              func: [
                () {
                  Get.back();
                }
              ],
              context: context,
            );
          } else {
            _detales.isShow == true
                ? _userModel.showWatchList!.add(id)
                : _userModel.movieWatchList!.add(id);
            _authController
                .saveUserDataLocally(model: _userModel)
                .then((value) async {
              platforMulti(
                isIos: _isIos,
                title: 'watchadd'.tr,
                buttonTitle: ["ok".tr],
                func: [
                  () {
                    Get.back();
                  }
                ],
                context: context,
              );

              _detales.timestamp = Timestamp.now();
              watchFav(path: path, upload: true);
            });
          }
          break;

        default:
      }
    }
  }

  // get episode trailer
  void episodeTrailer(
      {required String episode,
      required BuildContext context,
      required Widget content,
      required int index}) async {
    _detales.seaosn!.episodes![index].loading = true;
    update();
    bool check = _detales.isError == false;
    String id = check ? _detales.id.toString() : '';
    String season = check && _detales.seaosn!.isError == false
        ? _detales.seaosn!.seasonNumber.toString()
        : '';
    String lan = _userModel.language.toString().replaceAll('_', '-');
    await TrailerService()
        .getHomeInfo(
            link:
                'https://api.themoviedb.org/3/tv/$id/season/$season/episode/$episode/videos?api_key=$apiKey&language=$lan')
        .then((value) {
      _episodeModel = value;
      _detales.seaosn!.episodes![index].loading = false;
      update();
      trailerButton(content: content, context: context, model: value);
    });
  }

  // order the comments
  void commentOrder({required CommentOrder order, required bool isIos}) {
    if (_commentLoading == 0) {
      switch (order) {
        case CommentOrder.timeRecent:
          iosBack(isIos: isIos);
          _commentList.sort((a, b) => b.time.compareTo(a.time));
          break;
        case CommentOrder.timeOld:
          iosBack(isIos: isIos);
          _commentList.sort((a, b) => a.time.compareTo(b.time));
          break;
        case CommentOrder.mostLikes:
          iosBack(isIos: isIos);
          _commentList.sort((a, b) => b.likes.compareTo(a.likes));
          break;
        case CommentOrder.leastLikes:
          iosBack(isIos: isIos);
          _commentList.sort((a, b) => a.likes.compareTo(b.likes));
          break;
        case CommentOrder.replies:
          iosBack(isIos: isIos);
          _commentList.sort((a, b) => (b.subComments != null
                  ? b.subComments!.length
                  : 0)
              .compareTo(a.subComments != null ? a.subComments!.length : 0));
          break;
        default:
      }
      update();
    }
  }

  // back if ios
  void iosBack({required bool isIos}) {
    if (isIos) {
      Get.back();
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

  // add to keeping
  void addKeeping({required BuildContext context, required bool isIos}) async {
    if (_loading == 0 && _detales.isError == false) {
      if (isIos) {
        Get.back();
      }

      if (_userModel.watching!.contains(_detales.id.toString())) {
        platforMulti(
          isIos: _isIos,
          title: 'readykeep'.tr,
          buttonTitle: ["ok".tr],
          func: [
            () {
              Get.back();
            }
          ],
          context: context,
        );
      } else {
        await EpisodeKeepingService()
            .getData(
                link:
                    'https://api.themoviedb.org/3/tv/${_detales.id}?api_key=$apiKey&language=',
                lan: _userModel.language.toString(),
                isFire: false)
            .then(
          (epModel) async {
            if (epModel.isError == false) {
              _userModel.watching!.add(_detales.id.toString());
              await DataPref().setUser(_userModel).then(
                (value) async {
                  epModel.token = _userModel.messagingToken.toString();
                  await FirebaseServices()
                      .addEpisodeMe(
                          uid: _userModel.userId.toString(), model: epModel)
                      .then((_) async {
                    platforMulti(
                      isIos: _isIos,
                      title: 'keepadd'.tr,
                      buttonTitle: ["ok".tr],
                      func: [
                        () {
                          Get.back();
                        }
                      ],
                      context: context,
                    );

                    // check if the show data already exists

                    await FirebaseServices()
                        .getShowData(showId: _detales.id.toString())
                        .then((value) async {
                      DocumentReference myRef = FirebaseServices()
                          .ref
                          .doc(_userModel.userId.toString())
                          .collection(FirebaseMainPaths.keeping.name)
                          .doc(_detales.id.toString());
                      if (value.exists == false ||
                          (value.data() as Map<String, dynamic>)['id'] ==
                              null ||
                          value.data() == null ||
                          value.data() == {}) {
                        // no data on this show so add
                        epModel.refList = [myRef];
                        await FirebaseServices().addShowData(model: epModel);
                      } else {
                        // there's data so add my refrence and update
                        List<dynamic> lst = value.get('refList');
                        lst.add(myRef);
                        await FirebaseServices().updateShowData(
                            showId: _detales.id.toString(),
                            map: {'refList': lst});
                      }
                    });
                  });
                  // check if its in the watchlist and delete it
                  await FirebaseServices()
                      .userDocument(
                          uid: _userModel.userId.toString(),
                          collection: FirebaseUserPaths.watchlist.name,
                          docId: _detales.id.toString())
                      .then(
                    (val) async {
                      if (val.exists) {
                        await FirebaseServices().delDoc(
                            uid: _userModel.userId.toString(),
                            collection: FirebaseUserPaths.watchlist.name,
                            docId: _detales.id.toString());
                      }
                    },
                  );
                },
              );
            } else {
              platforMulti(
                isIos: _isIos,
                title: 'error'.tr,
                body: epModel.errorMessage.toString(),
                buttonTitle: ["ok".tr],
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
    }
  }
}
