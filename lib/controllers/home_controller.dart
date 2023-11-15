import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/models/result_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/chats_page/chat_controller.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_controller.dart';
import 'package:cineverse/pages/favorites_page/favourites_controller.dart';
import 'package:cineverse/pages/home_page/home_phone.dart';
import 'package:cineverse/pages/profile_page/profile_controller.dart';
import 'package:cineverse/pages/watchlist_page/watchlist_controller.dart';
import 'package:cineverse/services/home_page_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/constants.dart';

class HomeController extends GetxController {
  final UserModel _userModel = Get.find<AuthController>().userModel;
  UserModel get userModel => _userModel;

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  int _loading = 0;
  int get loading => _loading;

  final List<String> _links = [];
  List<String> get links => _links;

  final List<Widget> _pages = [
    const HomeTap(),
    const WatchlistController(),
    const FavouritesController(),
    const KeepingController(),
    const ChatController(),
    const ProfileController()
  ];
  List<Widget> get pages => _pages;

  ResultModel _trendings = ResultModel(results: [], isError: true);
  ResultModel _upcomingMovies = ResultModel(results: [], isError: true);
  ResultModel _popularShows = ResultModel(results: [], isError: true);
  ResultModel _popularMovies = ResultModel(results: [], isError: true);
  ResultModel _topMovies = ResultModel(results: [], isError: true);
  ResultModel _topShows = ResultModel(results: [], isError: true);
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
  List<ResultModel> _lists = [];
  List<ResultModel> get lists => _lists;

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
    // TODO: implement onInit
    super.onInit();
    _lists = [
      _trendings,
      _upcomingMovies,
      _popularMovies,
      _popularShows,
      _topMovies,
      _topShows
    ];
    apiCall();
  }

  // change page index
  void indexChange({required int index}) {
    _pageIndex = index;
    update();
  }

  void switching() async {
    print('theme is ${_userModel.theme}');
    if (_userModel.theme == ChosenTheme.light) {
      _userModel.theme = ChosenTheme.dark;
      print('turning dark theme on');
    } else {
      _userModel.theme = ChosenTheme.light;
      print('turning light theme on');
    }
    print(_userModel.theme);

    await Get.find<AuthController>()
        .saveUserDataLocally(model: _userModel)
        .then((value) => print('done and done'));
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
  }
}
