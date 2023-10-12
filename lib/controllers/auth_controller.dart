import 'package:cineverse/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final TargetPlatform platform;
  final UserModel _userModel;
  AuthController(this._userModel, {required this.platform});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;
  UserModel get userModel => _userModel;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  void pray() {
    print('tingz are here ------');
  }
}
