import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/move_model.dart';
import 'package:cineverse/models/result_details_model.dart';
import 'package:cineverse/models/result_model.dart';
import 'package:cineverse/services/home_page_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchMoreController extends GetxController {
  Move _info = Move(
    isSearch: false,
    model: ResultModel(isError: false, errorMessage: ''),
  );
  Move get info => _info;

  final TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  final AuthController _authController = Get.find<AuthController>();
  AuthController get authController => _authController;

  final HomeController _homeController = Get.find<HomeController>();
  HomeController get homeController => _homeController;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  ResultModel _model = ResultModel();
  ResultModel get model => _model;

  final FocusNode _fNode = FocusNode();
  FocusNode get focusNode => _fNode;

  bool _loading = false;
  bool get loading => _loading;

  bool _detect = false;
  bool get detect => _detect;

  bool _focus = false;
  bool get focus => _focus;

  String _qury = '';
  String get qury => _qury;

  @override
  void onInit() {
    super.onInit();

    _info = Get.arguments;
    _model = _info.model;
    _scrollController.addListener(scrollListener);
    _fNode.addListener(() {
      _focus = _fNode.hasFocus;
      update();
    });
  }

  @override
  void onClose() {
    super.onClose();

    _controller.dispose();
    _fNode.dispose();
    _scrollController.dispose();
    Get.delete<SearchMoreController>();
  }

  // clear search field
  void searchClear() {
    _controller.clear();
    _fNode.requestFocus();
  }

  // search
  void search(
      {required String query,
      required int page,
      required bool search,
      required bool loadMore,
      bool? add}) async {
    _detect = true;
    update();

    if (search && query == '') {
    } else {
      _qury = query;
      String lang =
          _authController.userModel.language.toString().replaceAll('_', '-');
      String link = search
          ? 'https://api.themoviedb.org/3/search/multi?api_key=$apiKey&language='
          : _info.link.toString();
      String end =
          search ? '$lang&query=$query&page=$page' : '$lang&page=$page';

      if (loadMore == false) {
        _loading = true;
        update();
      }

      await HomePageService()
          .getHomeInfo(link: link, language: end)
          .then((value) {
        add == true
            ? {
                _model.results =
                    _model.results! + (value.results as List<ResultsDetail>),
                _model.page = value.page
              }
            : _model = value;
        if (loadMore == false) {
          _loading = false;
        }
        update();
      });
    }
  }

  // listner for the scrollnig controller
  void scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      search(
          query: _qury,
          loadMore: true,
          search: _info.isSearch,
          page: (_model.page as int) + 1,
          add: true);
    }
  }
}
