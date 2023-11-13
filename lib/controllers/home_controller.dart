import 'dart:convert';

import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/chats_page/chat_controller.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_controller.dart';
import 'package:cineverse/pages/favorites_page/favourites_controller.dart';
import 'package:cineverse/pages/home_page/home_phone.dart';
import 'package:cineverse/pages/profile_page/profile_controller.dart';
import 'package:cineverse/pages/watchlist_page/watchlist_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  final UserModel _userModel = Get.find<AuthController>().userModel;
  UserModel get userModel => _userModel;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    apiCall();
  }

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

  // change page index
  void indexChange({required int index}) {
    _pageIndex = index;
    update();
  }

  void apiCall() async {
    _loading = 1;
    update();
    String url =
        'https://api.themoviedb.org/3/movie/upcoming?api_key=e11cff04b1fcf50079f6918e5199d691&language';
    try {
      var response = await http.get(Uri.parse(url));
      var result = jsonDecode(response.body);
      result['results'].forEach((thing) {
        _links.add(thing['backdrop_path']);
      });
      _loading = 0;

      print(result);
    } catch (e) {
      _loading = 0;
      update();
    }
    update();
  }
}
