import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  UserModel _model = UserModel();
  UserModel get model => _model;

  int _tab = 1;
  int get tab => _tab;

  bool _loading = false;
  bool get loading => _loading;

  List<List<MovieDetaleModel>> _lst = [];
  List<List<MovieDetaleModel>> get lst => _lst;

  int _commentCount = 0;
  int get commentCount => _commentCount;

  @override
  void onInit() {
    super.onInit();
    _model = Get.arguments ?? Get.find<HomeController>().userModel;
    _lst = [<MovieDetaleModel>[], <MovieDetaleModel>[], <MovieDetaleModel>[]];

    fireMovie(collection: FirebaseUserPaths.favorites);
    comments();
  }

  // change tabs
  void changeTabs({required int tab}) {
    if (tab != _tab) {
      _tab = tab;
      update();

      switch (_tab) {
        case 1:
          fireMovie(collection: FirebaseUserPaths.favorites);
          break;

        case 2:
          fireMovie(collection: FirebaseUserPaths.watchlist);
          break;

        case 3:
          fireMovie(collection: FirebaseUserPaths.keeping);
          break;
        default:
      }
    }
  }

  // back
  void goBack() {
    Get.back();
  }

  // get comments
  void comments() async {
    await FirebaseServices()
        .userCollections(
            uid: _model.userId.toString(),
            collection: FirebaseUserPaths.comments.name,
            order: false)
        .then(
      (value) {
        if (value.docs.isNotEmpty) {
          _commentCount = value.docs.length;
          update();
        }
      },
    );
  }

  // get movies and shows from firebase
  void fireMovie({required FirebaseUserPaths collection}) async {
    if (_lst[_tab - 1].isEmpty) {
      _loading = true;
      update();
      await FirebaseServices()
          .userCollections(
              uid: _model.userId.toString(),
              collection: collection.name,
              order: false)
          .then(
        (value) {
          if (value.docs.isNotEmpty) {
            for (var i = 0; i < value.docs.length; i++) {
              try {
                _lst[_tab - 1].add(MovieDetaleModel.fromMap(
                    value.docs[i].data() as Map<String, dynamic>,
                    fire: true));
                _loading = false;
                update();
              } catch (e) {
                _loading = false;
                update();
              }
            }
          } else {
            _loading = false;
            update();
          }
        },
      );
    }
  }

  // following someone
  void follow() {
    // save their id locally and save

    // update user data in firebase

    // add the adder's id to the person they added

    // notify the person they added
  }
}
