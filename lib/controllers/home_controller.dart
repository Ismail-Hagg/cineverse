import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final UserModel _userModel = Get.find<AuthController>().userModel;
  UserModel get userModel => _userModel;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print('we are here ---------');
  }

  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  // change page index
  void indexChange({required int index}) {
    _pageIndex = index;
    update();
  }
}
