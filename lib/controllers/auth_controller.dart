import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final TargetPlatform platform;
  UserModel _userModel;
  AuthController(this._userModel, {required this.platform});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _user = Rxn<User>();

  User? get user => _user.value;
  UserModel get userModel => _userModel;

  Map<FieldType, FocusNode> get nodes => _nodes;
  Map<FieldType, bool> get flips => _flips;
  Map<FieldType, TextEditingController> get txtControllers => _txtControllers;

  bool _passOb = true;
  bool get passOb => _passOb;

  bool _loading = false;
  bool get loading => _loading;

  final Map<FieldType, FocusNode> _nodes = {
    FieldType.loginEmail: FocusNode(),
    FieldType.loginPass: FocusNode(),
    FieldType.signupEmail: FocusNode(),
    FieldType.signupPass: FocusNode(),
    FieldType.signupUser: FocusNode()
  };

  final Map<FieldType, bool> _flips = {
    FieldType.loginEmail: false,
    FieldType.loginPass: false,
    FieldType.signupEmail: false,
    FieldType.signupPass: false,
    FieldType.signupUser: false
  };

  final Map<FieldType, TextEditingController> _txtControllers = {
    FieldType.loginEmail: TextEditingController(),
    FieldType.loginPass: TextEditingController(),
    FieldType.signupEmail: TextEditingController(),
    FieldType.signupPass: TextEditingController(),
    FieldType.signupUser: TextEditingController()
  };

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());

    setListeners();
  }

  @override
  void onClose() {
    nodesDispose();
    super.onClose();
  }

  // dispose of the focus nodes
  void nodesDispose() {
    _nodes.forEach((key, value) {
      value.dispose();
      _txtControllers[key]!.dispose();
    });
  }

  // unfocus all the focus nodes
  void unfocusNodes() {
    _nodes.forEach((key, value) {
      value.unfocus();
    });

    update();
  }

  // password field hidden or not
  void passObscure() {
    _passOb = !_passOb;
    update();
  }

  // setup listeners
  void setListeners() {
    _nodes.forEach((key, value) {
      value.addListener(() {
        if (value.hasFocus) {
          _flips[key] = true;
          update();
        } else {
          _flips[key] = false;
          update();
        }
      });
    });
  }

  // update the user model
  void userUpdate({required UserModel user}) {
    _userModel = user;
    DataPref()
        .setUser(_userModel)
        .then((value) => print("Operation is ===> $value"));
  }

  // switch the theme
  void themeSwich() {
    print(Get.isDarkMode ? "Normal" : "Dark Mode");
    _loading = !_loading;
    Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme);
    update();
  }
}
