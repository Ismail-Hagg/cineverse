import 'dart:math';

import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/models/result_details_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WatchlistController extends GetxController {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  final List<MovieDetaleModel> _lst = [];
  List<MovieDetaleModel> get lst => _lst;

  List<MovieDetaleModel> _searched = [];
  List<MovieDetaleModel> get searched => _searched;

  List<MovieDetaleModel> _afterGenre = [];
  List<MovieDetaleModel> get afterGenre => _afterGenre;

  final bool _isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  bool _loading = false;
  bool get loading => _loading;

  bool _newest = true;
  bool get newest => _newest;

  bool _search = false;
  bool get search => _search;

  bool _focus = false;
  bool get focus => _focus;

  bool _genreFilter = false;
  bool get genreFilter => _genreFilter;

  final FocusNode _fNode = FocusNode();
  FocusNode get focusNode => _fNode;

  final TextEditingController _txtController = TextEditingController();
  TextEditingController get txtController => _txtController;

  String _query = '';
  String get query => _query;

  List<String> _genres = [];
  List<String> get genres => _genres;

  final List<String> _genresFiltered = [];
  List<String> get genresFiltered => _genresFiltered;

  @override
  void onInit() {
    super.onInit();
    _userModel = Get.find<AuthController>().userModel;
    getWatchlist();
    setLestiner();
  }

  @override
  void onClose() {
    super.onClose();
    _fNode.dispose();
    _txtController.dispose();
  }

  // add chosen genre
  void addGenre({required bool contains, required String genre}) {
    contains ? _genresFiltered.remove(genre) : _genresFiltered.add(genre);
    update();
    filterGenre();
  }

  // filter by genres
  void filterGenre() {
    _afterGenre = [];
    for (var i = 0; i < _lst.length; i++) {
      if (_lst[i].genres!.toSet().containsAll(_genresFiltered)) {
        _afterGenre.add(_lst[i]);
      }
    }
  }

  // get genres
  void genreCollect() {
    List<String> temList = [];
    for (var i = 0; i < lst.length; i++) {
      var type = lst[i].isShow == true ? 'Show' : 'Movie';
      temList = [type, ...temList, ...lst[i].genres as List<String>];
    }
    _genres = temList.toSet().toList();
  }

  // search
  void searching({required String input}) {
    if (input.trim() != '') {
      _query = input;
      update();
      final suggestion = _lst.where(
        (element) {
          final name = element.title.toString().toLowerCase();
          return name.contains(input.trim().toLowerCase());
        },
      ).toList();
      _searched = suggestion;
      update();
    } else {
      _searched.clear();

      _query = '';
      update();
    }
  }

  // search field focused
  void setLestiner() {
    _fNode.addListener(
      () {
        _focus = _fNode.hasFocus;
        update();
      },
    );
  }

  // clear search field
  void clearSearch() {
    _txtController.clear();
    _query = '';
    _searched.clear();
    _fNode.requestFocus();
    update();
  }

  // unfocus
  void unfocus() {
    _fNode.unfocus();
    update();
  }

  // open search box
  void openSearch() {
    _search = !_search;
    if (_genreFilter == true) {
      _genreFilter = !_genreFilter;
    }
    update();
  }

  // open genre filter
  void openGenreFilter() {
    _genreFilter = !_genreFilter;
    if (_search == true) {
      _search = !_search;
    }
    update();
  }

  // order ascending or descending
  void orderFlip() {
    if (_loading == false) {
      _newest = !_newest;
      if (_newest) {
        _lst.sort(
            (a, b) => b.timestamp!.toDate().compareTo(a.timestamp!.toDate()));
      } else {
        _lst.sort(
            (a, b) => a.timestamp!.toDate().compareTo(b.timestamp!.toDate()));
      }
      update();
    }
  }

  // random
  void randomMovie() {
    int randomNum = Random().nextInt(_lst.length);
    detaleNav(movie: _lst[randomNum]);
  }

  // delete from watchlist
  void watchDelete({required int index}) async {
    MovieDetaleModel model = _search == true && _searched.isNotEmpty
        ? _searched[index]
        : _genreFilter == true && _afterGenre.isNotEmpty
            ? _afterGenre[index]
            : lst[index];
    lst.remove(model);
    if (_searched.contains(model)) {
      _searched.remove(model);
    }
    if (_afterGenre.contains(model)) {
      _afterGenre.remove(model);
    }
    update();
    if (model.isShow == true) {
      _userModel.showWatchList!.remove(model.id.toString());
    } else {
      _userModel.movieWatchList!.remove(model.id.toString());
    }
    await DataPref().setUser(_userModel).then(
      (value) async {
        await FirebaseServices().watchFav(
            userId: _userModel.userId.toString(),
            path: FirebaseUserPaths.watchlist,
            model: model,
            upload: false);
      },
    );
  }

  // get watchlist from firebase
  void getWatchlist() async {
    _loading = true;
    update();
    await FirebaseServices()
        .userCollections(
            uid: _userModel.userId.toString(),
            collection: FirebaseUserPaths.watchlist.name,
            orderby: 'timestamp',
            ascend: false,
            order: true)
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          for (var i = 0; i < value.docs.length; i++) {
            Map<String, dynamic> data =
                value.docs[i].data() as Map<String, dynamic>;
            _lst.add(MovieDetaleModel.fromMap(data, fire: true));
            var type = lst[i].isShow == true ? 'Show' : 'Movie';
            _lst[i].genres!.add(type);
          }
        }
        _loading = false;
        update();
        genreCollect();
      },
    );
  }

  // nav to detale page
  void navToDetale({required int index}) {
    detaleNav(
        movie: _search == true && _searched.isNotEmpty
            ? _searched[index]
            : _genreFilter == true && _afterGenre.isNotEmpty
                ? _afterGenre[index]
                : lst[index]);
  }

  // nav to detales
  void detaleNav({required MovieDetaleModel movie}) {
    _fNode.unfocus();
    ResultsDetail res = ResultsDetail(
        backdropPath: '',
        id: movie.id,
        overview: movie.overview,
        posterPath: movie.posterPath,
        releaseDate: movie.releaseDate,
        title: movie.title,
        voteAverage: movie.voteAverage,
        mediaType: movie.isShow == true ? 'tv' : 'movie',
        isShow: movie.isShow);
    Get.find<HomeController>().navToDetale(res: res);
  }
}
