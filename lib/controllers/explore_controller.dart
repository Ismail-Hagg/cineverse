import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/models/result_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/actor_search_service.dart';
import 'package:cineverse/services/explore_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/countries.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExploreController extends GetxController {
  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  final bool _isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  final UserModel _userModel = Get.find<AuthController>().userModel;
  UserModel get userModel => _userModel;

  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');

  int _actorLoading = 0;
  int get actorLoading => _actorLoading;

  int _page = 1;
  int get page => _page;

  String _year = '';
  String get year => _year;

  String _country = '';
  String get country => _country;

  String _link = '';
  String get link => _link;

  String _countryCode = '';
  String get countryCode => _countryCode;

  final Map<String, String> _people = {};
  Map<String, String> get people => _people;

  final Map<String, Map<String, String>> _apiActor = {};
  Map<String, Map<String, String>> get apiActor => _apiActor;

  final List<String> _genres = [];
  List<String> get genres => _genres;

  final List<String> _names = [];
  List<String> get names => _names;

  final List<int> _years = List.generate(2150 - 1900, (i) => 1900 + i);
  List<int> get years => _years;

  final List<Map<String, String>> _countries = apiCountries;
  List<Map<String, String>> get countries => _countries;

  FilterChoice _choice = FilterChoice.movie;
  FilterChoice get choice => _choice;

  bool _useYear = false;
  bool get useYear => _useYear;

  bool _usecountry = false;
  bool get usecountry => _usecountry;

  bool _mainLoader = false;
  bool get mainLoader => _mainLoader;

  ResultModel _model = ResultModel();
  ResultModel get model => _model;

  @override
  void onInit() {
    super.onInit();
    _year = formatter.format(now).substring(0, 4);
    getCountry();
    _scrollController.addListener(scrollListener);
  }

  @override
  void onClose() {
    super.onClose();
    _scrollController.dispose();
  }

  // call the api
  void apiCall({bool? pageUp}) async {
    if (pageUp == null) {
      Get.back();
      _page = 1;
      _mainLoader = true;
      update();
    } else {
      _page++;
    }
    var key = '&api_key=$apiKey';
    var movieOrTv = _choice.name;
    var lan = _userModel.language.toString().substring(0, 2);
    var year = useYear == true
        ? '&${_choice == FilterChoice.movie ? 'primary_release_year' : 'first_air_date_year'}=$_year'
        : '';
    var genres =
        _genres.isNotEmpty ? '&with_genres=${makeGenre(lst: _genres)}' : '';
    var count = usecountry == true ? '&with_origin_country=$_countryCode' : '';
    var pope = _people.isNotEmpty ? '&with_people=${popes(map: _people)}' : '';

    _link =
        'https://api.themoviedb.org/3/discover/$movieOrTv?language=$lan&page=$_page$year&sort_by=primary_release_date.desc$genres$count$pope$key';
    print(link);
    await ExploreService().goExolore(link: link).then(
      (value) {
        if (pageUp == null) {
          _model = value;
          _mainLoader = false;
          update();
        } else {
          _model.results = [..._model.results ?? [], ...value.results ?? []];
          update();
        }
      },
    );
  }

  String makeGenre({required List<String> lst}) {
    var joined = '';
    for (var i = 0; i < lst.length; i++) {
      joined = i == 0 ? lst[i] : '$joined,${lst[i]}';
    }
    return joined;
  }

  String popes({required Map<String, String> map}) {
    var joined = '';
    map.forEach((key, value) {
      joined == '' ? joined = value : joined = '$joined,$value';
    });
    return joined;
  }

  // use year and country off and on
  void useSwitch({required String swaitch}) {
    if (swaitch == 'year') {
      _useYear = !_useYear;
    } else {
      _usecountry = !_usecountry;
    }
    update();
  }

  // add genres
  void addGenres({required String genreId}) {
    if (_genres.contains(genreId)) {
      _genres.remove(genreId);
    } else {
      _genres.add(genreId);
    }

    update();
  }

  // change country
  void countryChanged({required String country}) {
    _country = country;
    update();
    for (var i = 0; i < _countries.length; i++) {
      if (_countries[i][_userModel.language.toString().toLowerCase()] ==
          country) {
        _countryCode = _countries[i]['iso_3166_1'].toString();
        break;
      }
    }
  }

  // change choice
  void choiceChanged({required FilterChoice flip}) {
    _choice = flip;
    update();
  }

  void getCountry() {
    _countryCode = WidgetsBinding.instance.platformDispatcher.locale.countryCode
        .toString();
    for (var i = 0; i < _countries.length; i++) {
      if (_countries[i]['iso_3166_1'] == _countryCode) {
        _country = _countries[i][_userModel.language!.toLowerCase()].toString();
      }
    }
    update();
  }

  // change the year
  void yearChange({required String newYear}) {
    _year = newYear;
    update();
  }

  // add person
  void peopleAdd({required String name, required String id}) {
    Get.back();
    _people[name] = id;
    _apiActor.clear();
    _names.clear();
    update();
  }

  // actor loading
  void loadingActor({required String actor}) async {
    if (actor.trim() != '') {
      _actorLoading = 1;
      update();
      _apiActor.clear();
      _names.clear();
      String lang = _userModel.language.toString().substring(0, 2);
      await ActorSearch()
          .getHomeInfo(
              link:
                  'https://api.themoviedb.org/3/search/person?query=${actor.trim()}&language=$lang&page=1&api_key=$apiKey')
          .then(
        (value) {
          if (value != []) {
            for (var i = 0; i < value.length; i++) {
              String name = value[i]['name'];
              String id = value[i]['id'].toString();
              String pic = value[i]['profile_path'] ?? '';
              _names.add(name);
              _apiActor[name] = {'id': id, 'pic': pic, 'name': name};
            }
            _actorLoading = 0;
            update();
          }
        },
      );
    } else {
      if (_isIos) {
        Get.back();
      }
    }
  }

  // search dialog
  void searchDialog({
    required BuildContext context,
    required Widget content,
  }) async {
    _isIos
        ? showCupertinoDialog(context: context, builder: (context) => content)
        // ignore: unused_result
        : showAlertDialog(
            context: context,
            builder: (context, child) => content,
          );
  }

  // remove person
  void peopleRemove({required String key}) {
    _people.remove(key);
    update();
  }

  // open the bottom thing to change data
  void openBottom({required BuildContext context, required Widget widget}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return widget;
      },
    );
  }

  // listner for the scrollnig controller
  void scrollListener() async {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_model.isError == false &&
          _model.totalResults != 0 &&
          _page < int.parse(_model.totalPages.toString())) {
        apiCall(pageUp: true);
      }
    }
  }
}
