import 'dart:io';

import 'package:cineverse/controllers/actor_controller.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/chat_controller.dart';
import 'package:cineverse/controllers/favorites_controller.dart';
import 'package:cineverse/controllers/keeping_controller.dart';
import 'package:cineverse/controllers/profile_controller.dart';
import 'package:cineverse/controllers/wachlist_controller.dart';
import 'package:cineverse/models/actor_model.dart';
import 'package:cineverse/models/cast_model.dart';
import 'package:cineverse/models/collection_model.dart';
import 'package:cineverse/models/move_model.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/models/result_details_model.dart';
import 'package:cineverse/models/result_model.dart';
import 'package:cineverse/models/season_model.dart';
import 'package:cineverse/models/trailer_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/actor_page/actor_controller.dart';
import 'package:cineverse/pages/chats_page/chat_controller.dart';
import 'package:cineverse/pages/detale_page/detale_controller.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_controller.dart';
import 'package:cineverse/pages/favorites_page/favourites_controller.dart';
import 'package:cineverse/pages/home_page/home_phone.dart';
import 'package:cineverse/pages/profile_page/profile_controller.dart';
import 'package:cineverse/pages/search_page/search_controller.dart';
import 'package:cineverse/pages/watchlist_page/watchlist_controller.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/services/home_page_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';
import 'movie_detale_controller.dart';

class HomeController extends GetxController {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  int _loading = 0;
  int get loading => _loading;

  final List<String> _links = [];
  List<String> get links => _links;

  final List<Widget> _pages = [
    const HomeTap(),
    const WatchlistViewController(),
    const FavouritesViewController(),
    const KeepingViewController(),
    const ChatViewController(),
    const ProfileViewController()
  ];
  List<Widget> get pages => _pages;

  ResultModel _trendings = ResultModel(results: [], isError: false);
  ResultModel _upcomingMovies = ResultModel(results: [], isError: false);
  ResultModel _popularShows = ResultModel(results: [], isError: false);
  ResultModel _popularMovies = ResultModel(results: [], isError: false);
  ResultModel _topMovies = ResultModel(results: [], isError: false);
  ResultModel _topShows = ResultModel(results: [], isError: false);
  //MovieDetaleModel _movieDetales = MovieDetaleModel();

  ResultModel get trendings => _trendings;
  ResultModel get upcomingMovies => _upcomingMovies;
  ResultModel get popularMovies => _popularMovies;
  ResultModel get popularShows => _popularShows;
  ResultModel get topMovies => _topMovies;
  ResultModel get topShows => _topShows;
  //MovieDetaleModel get movieDetales => _movieDetales;

  final List<String> _urls = [trending, upcoming, pop, popularTv, top, topTv];
  List<String> get urls => _urls;

  final List<String> _translation = [
    'trend'.tr,
    'upcoming'.tr,
    'popularMovies'.tr,
    'popularShows'.tr,
    'topMovies'.tr,
    'topShowa'.tr,
  ];
  List<String> get translations => _translation;

  @override
  void onInit() {
    super.onInit();
    _userModel = Get.find<AuthController>().userModel;

    apiCall();
  }

  // change page index
  void indexChange({required int index}) {
    if (index != _pageIndex) {
      _pageIndex = index;
      update();
      switch (index) {
        case 0:
          if (Get.isRegistered<FavoritesController>()) {
            Get.delete<FavoritesController>();
          }
          if (Get.isRegistered<KeepingController>()) {
            Get.delete<KeepingController>();
          }
          if (Get.isRegistered<ChatController>()) {
            Get.delete<ChatController>();
          }
          if (Get.isRegistered<ProfilePageController>()) {
            Get.delete<ProfilePageController>();
          }
          if (Get.isRegistered<WatchlistController>()) {
            Get.delete<WatchlistController>();
          }
          break;

        case 1:
          if (Get.isRegistered<FavoritesController>()) {
            Get.delete<FavoritesController>();
          }
          if (Get.isRegistered<KeepingController>()) {
            Get.delete<KeepingController>();
          }
          if (Get.isRegistered<ChatController>()) {
            Get.delete<ChatController>();
          }
          if (Get.isRegistered<ProfilePageController>()) {
            Get.delete<ProfilePageController>();
          }
          break;

        case 2:
          if (Get.isRegistered<WatchlistController>()) {
            Get.delete<WatchlistController>();
          }
          if (Get.isRegistered<KeepingController>()) {
            Get.delete<KeepingController>();
          }
          if (Get.isRegistered<ChatController>()) {
            Get.delete<ChatController>();
          }
          if (Get.isRegistered<ProfilePageController>()) {
            Get.delete<ProfilePageController>();
          }
          break;

        case 3:
          if (Get.isRegistered<FavoritesController>()) {
            Get.delete<FavoritesController>();
          }
          if (Get.isRegistered<WatchlistController>()) {
            Get.delete<WatchlistController>();
          }
          if (Get.isRegistered<ChatController>()) {
            Get.delete<ChatController>();
          }
          if (Get.isRegistered<ProfilePageController>()) {
            Get.delete<ProfilePageController>();
          }
          break;

        case 4:
          if (Get.isRegistered<FavoritesController>()) {
            Get.delete<FavoritesController>();
          }
          if (Get.isRegistered<KeepingController>()) {
            Get.delete<KeepingController>();
          }
          if (Get.isRegistered<WatchlistController>()) {
            Get.delete<WatchlistController>();
          }
          if (Get.isRegistered<ProfilePageController>()) {
            Get.delete<ProfilePageController>();
          }
          break;

        case 5:
          if (Get.isRegistered<FavoritesController>()) {
            Get.delete<FavoritesController>();
          }
          if (Get.isRegistered<KeepingController>()) {
            Get.delete<KeepingController>();
          }
          if (Get.isRegistered<WatchlistController>()) {
            Get.delete<WatchlistController>();
          }
          if (Get.isRegistered<ChatController>()) {
            Get.delete<ChatController>();
          }
          break;
        default:
      }
    }
  }

  // upload image to firebase
  void imageUplad() async {
    checking(
        type: _userModel.avatarType as AvatarType,
        pic: _userModel.localPicPath.toString());
    if (_userModel.avatarType == AvatarType.local &&
        _userModel.onlinePicPath == '') {
      await FirebaseServices()
          .uploadUserImage(
        userId: _userModel.userId.toString(),
        file: _userModel.localPicPath.toString(),
      )
          .then(
        (value) async {
          _userModel.onlinePicPath = value;
          Get.find<AuthController>()
              .saveUserDataLocally(model: _userModel)
              .then(
                (value) => Get.find<AuthController>().userUpdate(
                  userId: _userModel.userId.toString(),
                  map: {
                    'onlinePicPath': _userModel.onlinePicPath.toString(),
                  },
                ),
              );
        },
      ).onError((error, stackTrace) {
        print('=== $error');
      });
    }
  }

  // check if the profile pic is in the phone
  void checking({required AvatarType type, required String pic}) async {
    if (type == AvatarType.local) {
      await File(pic).exists().then(
        (value) async {
          if (!value) {
            _userModel.avatarType = AvatarType.online;
            await Get.find<AuthController>()
                .saveUserDataLocally(model: _userModel)
                .then(
              (value) async {
                await FirebaseServices().userUpdate(
                    userId: _userModel.userId.toString(),
                    map: {'avatarType': _userModel.avatarType.toString()});
              },
            );
          }
        },
      );
      update();
    }
  }

  // call api
  void apiCall() async {
    _loading = 1;
    update();

    for (var i = 0; i < _urls.length; i++) {
      await HomePageService()
          .getHomeInfo(link: _urls[i], language: _userModel.language.toString())
          .then((value) {
        switch (i) {
          case 0:
            _trendings = value;
            break;
          case 1:
            _upcomingMovies = value;
            break;

          case 2:
            _popularMovies = value;
            break;
          case 3:
            _popularShows = value;
            break;
          case 4:
            _topMovies = value;
            break;
          case 5:
            _topShows = value;
            break;
        }
      });
    }
    _loading = 0;
    update();
    imageUplad();
  }

  // navigate to the detale page
  void navToDetale({required ResultsDetail res}) {
    if (res.mediaType == 'person') {
      Get.create(() => ActorController());
      Get.to(() => const ActorViewController(),
          arguments: ActorModel(
            detales: ActorDetale(
                actedMovies: [], actedShows: [], directed: [], produced: []),
            link: res.posterPath,
            name: res.title,
            isError: false,
            errorMessage: '',
            birth: '',
            id: res.id,
            bio: '',
          ),
          transition: Transition.native,
          preventDuplicates: false);
    } else {
      MovieDetaleModel movieDetales = MovieDetaleModel(
          cast: CastModel(isError: true),
          recomendation: ResultModel(isError: true),
          collection: CollectionModel(isError: true),
          isError: false,
          trailer: TrailerModel(isError: true),
          id: res.id,
          posterPath: res.posterPath,
          overview: res.overview,
          voteAverage: double.parse(res.voteAverage.toString()),
          title: res.title,
          isShow: res.isShow,
          runtime: 0,
          genres: null,
          releaseDate: res.releaseDate,
          seaosn: SeasonModel(isError: true, seasonNumber: 1),
          originCountry: '');

      Get.create(
        () => (MovieDetaleController()),
        //',
        permanent: true,
      );
      Get.to(() => const DetalePageController(),
          transition: Transition.native,
          preventDuplicates: false,
          arguments: movieDetales);
    }
  }

  // nav to search or more page
  void navToSearch(
      {required bool isSearch,
      String? title,
      String? link,
      required ResultModel model}) {
    Move moving =
        Move(isSearch: isSearch, link: link, title: title, model: model);
    Get.to(
      () => const SearchViewController(),
      arguments: moving,
      transition: Transition.native,
    );
  }
}
