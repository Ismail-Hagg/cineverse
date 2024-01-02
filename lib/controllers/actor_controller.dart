import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/actor_model.dart';
import 'package:cineverse/models/image_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/actor_detales_service.dart';
import 'package:cineverse/services/actor_service.dart';
import 'package:cineverse/services/image_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActorController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ActorModel _actor = ActorModel();
  ActorModel get actor => _actor;

  String _tag = '';
  String get tag => _tag;

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  ImagesModel _imageModel = ImagesModel(isError: true);
  ImagesModel get imageModel => _imageModel;

  late AnimationController _controller;
  AnimationController get controller => _controller;

  int _imagesCounter = 0;
  int get imagesCounter => _imagesCounter;

  bool _storyOpen = false;
  bool get storyOpen => _storyOpen;

  bool _loading = false;
  bool get loading => _loading;

  @override
  void onInit() {
    super.onInit();
    _actor = Get.arguments ?? ActorModel();
    _userModel = Get.find<HomeController>().userModel;

    _controller = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _tag = _actor.id.toString();
    actorData();
  }

  // call api to get images
  void getImages(
      {required double height,
      required double width,
      required bool isActor,
      required String id,
      required Widget content,
      required bool isIos}) async {
    if (_loading == false) {
      _imageModel = ImagesModel(isError: true);
      _imagesCounter = 1;
      update();
      Get.dialog(content);
      ImagesService()
          .getImages(
              media: 'person',
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

  // get the actor data
  void actorData() async {
    _loading = true;
    update();
    await ActorService()
        .getHomeInfo(
            link:
                'https://api.themoviedb.org/3/person/${_actor.id}?api_key=$apiKey&language=${_userModel.language.toString().substring(0, 2)}')
        .then(
      (actor) async {
        if (actor.isError == false) {
          _actor = actor;
          await ActorDetaleService()
              .getHomeInfo(
                  link:
                      'https://api.themoviedb.org/3/person/${_actor.id}/combined_credits?api_key=$apiKey&language=${_userModel.language.toString().substring(0, 2)}')
              .then(
            (value) {
              _actor.detales = value;
              _loading = false;
              update();
            },
          );
        } else {
          _actor.isError = true;
          _actor.errorMessage = actor.errorMessage;
          _loading = false;
          update();
        }
      },
    );
  }
}
