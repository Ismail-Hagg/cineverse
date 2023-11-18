import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/cast_service.dart';
import 'package:cineverse/services/movie_detale_service.dart';
import 'package:cineverse/services/recommendation_service.dart';
import 'package:cineverse/services/trailer_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MovieDetaleController extends GetxController
    with GetSingleTickerProviderStateMixin {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;
  late MovieDetaleModel _detales;
  MovieDetaleModel get detales => _detales;

  int _loading = 0;
  int get loading => _loading;

  int _tabs = 1;
  int get tabs => _tabs;

  bool _storyOpen = false;
  bool get storyOpen => _storyOpen;

  late AnimationController _controller;
  AnimationController get controller => _controller;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _userModel = Get.find<AuthController>().userModel;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _detales = Get.arguments ?? MovieDetaleModel(isError: true);

    getData(res: _detales);
  }

  @override
  void onClose() {
    // TODO: implement onInit
    super.onClose();
    _controller.dispose();
  }

  // get data from api
  void getData({required MovieDetaleModel res}) async {
    _loading = 1;
    update();
    var lan = _userModel.language.toString().replaceAll('_', '-');
    var show = res.isShow == true ? 'tv' : 'movie';
    var base = 'https://api.themoviedb.org/3/$show/${res.id}';
    var end = '?api_key=$apiKey&language=$lan';
    List<String> slashes = ['', '/credits', '/recommendations', '/videos'];

    for (var i = 0; i < slashes.length; i++) {
      switch (i) {
        case 0:
          await MovieDetaleService()
              .getHomeInfo(link: '$base${slashes[i]}$end')
              .then((value) {
            if (value.isError == false) {
              _detales = value;
            }
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
              .then((value) => {
                    _detales.recomendation = value,
                  });
          break;
        case 3:
          await TrailerService()
              .getHomeInfo(link: '$base/${slashes[i]}$end')
              .then((value) => {_detales.trailer = value});
          break;
      }
    }
    _loading = 0;
    update();
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
}
