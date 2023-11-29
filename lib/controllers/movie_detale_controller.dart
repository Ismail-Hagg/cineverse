import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/models/comment_model.dart';
import 'package:cineverse/models/image_model.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/models/trailer_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/cast_service.dart';
import 'package:cineverse/services/collection_service.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/services/image_service.dart';
import 'package:cineverse/services/movie_detale_service.dart';
import 'package:cineverse/services/recommendation_service.dart';
import 'package:cineverse/services/season_service.dart';
import 'package:cineverse/services/trailer_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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

  int _loading = 0;
  int get loading => _loading;

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

  List<CommentModel> commentList = [
    CommentModel(
      commentId: 'commentId',
      userId: 'userId',
      userName: 'userName',
      userLink:
          'https://stylesatlife.com/wp-content/uploads/2023/08/Beautiful-Zendaya-Pic-in-a-Yellow-Swim-Bikini.jpg',
      time: DateTime.now(),
      comment:
          'comment comment comment comment comment comment comment comment comment',
      likes: 1,
      dislikea: 0,
      hasMore: false,
      token: '',
      commentOpen: false,
      repliesNum: 0,
    ),
    CommentModel(
      commentId: 'commentId',
      userId: Get.find<AuthController>().userModel.userId.toString(),
      userName: 'scarlett johanson',
      userLink:
          'https://hips.hearstapps.com/hmg-prod/images/american-actress-scarlett-johansson-at-cannes-film-festival-news-photo-1685449533.jpg',
      time: DateTime.now(),
      comment:
          'comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment commentcomment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment comment',
      likes: 0,
      dislikea: 0,
      hasMore: true,
      token: '',
      commentOpen: false,
      repliesNum: 2,
    )
  ];

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

  // comment flip
  void commentFlip() {
    _commentOpen = !_commentOpen;
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

  // get data from api
  void getData({required MovieDetaleModel res}) async {
    _loading = 1;
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
    _tabs = tab;
    update();
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
      required TrailerModel? model}) async {
    if (_loading == 0 && model!.isError == false) {
      if (model.results!.isEmpty) {
        await showOkAlertDialog(
          context: context,
          title: 'trailer'.tr,
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
        await showOkAlertDialog(
            context: context, title: 'error'.tr, message: value.$2);
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
    }).onError((error, stackTrace) {
      print('error ==> $error');
    });
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
              (error, stackTrace) async {
                _userModel.favs!.add(id);
                update();
                await showOkAlertDialog(
                  context: context,
                  title: 'error'.tr,
                  message: error.toString(),
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
            ).catchError((error, stackTrace) async {
              _userModel.favs!.remove(id);
              update();
              await showOkAlertDialog(
                context: context,
                title: 'error'.tr,
                message: error.toString(),
              );
            });
          }
          break;
        case FirebaseUserPaths.watchlist:
          bool contain = _detales.isShow == true
              ? _userModel.showWatchList!.contains(id)
              : _userModel.movieWatchList!.contains(id);
          if (contain) {
            // desplay message that sais already in watchlist
            await showOkAlertDialog(
              context: context,
              title: 'watchalready'.tr,
            );
          } else {
            _detales.isShow == true
                ? _userModel.showWatchList!.add(id)
                : _userModel.movieWatchList!.add(id);
            _authController
                .saveUserDataLocally(model: _userModel)
                .then((value) async {
              await showOkAlertDialog(
                context: context,
                title: 'watchadd'.tr,
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
}
