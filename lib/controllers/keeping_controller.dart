import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/model_exports.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeepingController extends GetxController {
  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  final List<EpisodeModeL> _list = [];
  List<EpisodeModeL> get lsit => _list;

  final Map<String, Map<String, int>> _store = {};
  Map<String, Map<String, int>> get store => _store;

  bool _loading = false;
  bool get loading => _loading;

  final bool _isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
  bool get isIos => _isIos;

  @override
  void onInit() {
    super.onInit();
    getKeepint();
  }

  @override
  void onClose() {
    super.onClose();
    opened();
  }

  // get the keeping
  void getKeepint() async {
    _loading = true;
    update();
    await FirebaseServices()
        .userCollections(
            uid: _userModel.userId.toString(),
            collection: FirebaseUserPaths.keeping.name,
            order: true,
            ascend: false,
            orderby: 'change')
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (var i = 0; i < value.docs.length; i++) {
          _list.add(
            EpisodeModeL.fromMap(
                value.docs[i].data() as Map<String, dynamic>, true),
          );
          _store[(value.docs[i].data() as Map<String, dynamic>)['id']
              .toString()] = {
            'episode':
                (value.docs[i].data() as Map<String, dynamic>)['myEpisode'],
            'season': (value.docs[i].data() as Map<String, dynamic>)['mySeason']
          };
        }
      }
      _loading = false;
      update();
    });
  }

  // nav to show
  void showNav({required EpisodeModeL model}) {
    Get.find<HomeController>().navToDetale(
      res: ResultsDetail(
          voteAverage: model.voteAverage,
          id: model.id,
          overview: model.overView,
          releaseDate: model.releaseDate!.substring(0, 4),
          title: model.name,
          mediaType: 'tv',
          isShow: true,
          genreIds: [],
          posterPath: model.pic),
    );
  }

  // open the bottom thing to change data
  void openBottom(
      {required int index,
      required BuildContext context,
      required Widget widget}) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return widget;
      },
    );
  }

  // editing
  void editing({required int index, required bool add, required bool episode}) {
    if (add) {
      episode
          ? _list[index].myEpisode = _list[index].myEpisode! + 1
          : _list[index].mySeason = _list[index].mySeason! + 1;
      update();
    } else {
      episode
          ? _list[index].myEpisode == 1
              ? null
              : _list[index].myEpisode = _list[index].myEpisode! - 1
          : _list[index].mySeason == 1
              ? null
              : _list[index].mySeason = _list[index].mySeason! - 1;
      update();
    }
  }

  // catching up fase
  void fastCatch({required int index}) {
    _list[index].myEpisode = _list[index].episode;
    _list[index].mySeason = _list[index].season;
    update();
  }

  // delete from keeping
  void keepDelete({required int index}) async {
    Get.back();
    EpisodeModeL tempOne = _list[index];

    // delete from the list and update ui
    _list.remove(tempOne);
    update();

    // delete from local storage and update user data locally and in firebase
    _userModel.watching!.remove(tempOne.id.toString());
    await DataPref().setUser(_userModel).then(
      (value) async {
        await FirebaseServices()
            .userUpdate(
                userId: _userModel.userId.toString(), map: _userModel.toMap())
            .then(
          (_) async {
            // delete from keeping in firebase
            await FirebaseServices()
                .delDoc(
                    uid: _userModel.userId.toString(),
                    collection: FirebaseUserPaths.keeping.name,
                    docId: tempOne.id.toString())
                .then(
              (_) async {
                // delete from other collection in order not to get notification on the show
                await FirebaseServices()
                    .getKeepingDetale(movieId: tempOne.id.toString())
                    .then((value) async {
                  Map<String, dynamic> newOp =
                      value.data() as Map<String, dynamic>;
                  DocumentReference myRef = FirebaseServices()
                      .ref
                      .doc(_userModel.userId.toString())
                      .collection(FirebaseUserPaths.keeping.name)
                      .doc(tempOne.id.toString());
                  List<dynamic> refList = newOp['refList'];
                  refList.remove(myRef);
                  newOp['refList'] = refList;
                  await FirebaseServices().updateKeepingDetale(
                      movieId: tempOne.id.toString(), map: newOp);
                });
              },
            );
          },
        );
      },
    );
  }

  // after editing
  void afterEdit({
    required int index,
  }) async {
    Get.back();
    if (_list[index].myEpisode !=
            _store[_list[index].id.toString()]!['episode'] ||
        _list[index].mySeason !=
            _store[_list[index].id.toString()]!['season']) {
      _store[_list[index].id.toString()]!['season'] =
          _list[index].mySeason as int;
      _store[_list[index].id.toString()]!['episode'] =
          _list[index].myEpisode as int;
      _list[index].change = Timestamp.now();
      EpisodeModeL episode = _list[index];
      _list.sort(
        (a, b) => b.change!.toDate().compareTo(
              a.change!.toDate(),
            ),
      );

      update();
      await FirebaseServices().addEpisodeMe(
          uid: _userModel.userId.toString(), model: episode, update: true);
    }
  }

  // meke isUpdate false
  void opened() async {
    for (var i = 0; i < _list.length; i++) {
      if (_list[i].isUpdated == true) {
        _list[i].isUpdated = false;
        await FirebaseServices().addEpisodeMe(
            uid: _userModel.userId.toString(), model: _list[i], update: true);
      }
    }
  }
}
