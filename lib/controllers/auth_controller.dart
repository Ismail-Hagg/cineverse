import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/otp_page/otp_controller.dart';
import 'package:cineverse/pages/pre_otp_page/pre_otp_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../utils/functions.dart';

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

  String _phoneCountry = '';
  String get phoneCountry => _phoneCountry;

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
    // _loading = !_loading;
    Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme);
    update();
  }

  // logout
  void signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    await DataPref().deleteUser();
    update();
  }

  // phone login  start
  phoneLoginStart({required BuildContext context}) async {
    // start the loading animation
    _loading = true;
    update();

    // check if we can get the phone number throught the plugin
    await SmsAutoFill().hint.then((value) async {
      if (value.toString() != 'null') {
        // phone number was chosen so excute phone login and go to otp page

        // turn off the loading animation
        _loading = false;
        update();
      } else {
        // no phone number was chosen so go to pre otp page
        Get.to(() => const PreOtpController());

        // turn off the loading animation
        _loading = false;
        update();
      }
    });
  }

  // set phone numbrt in usermodel
  void moedelPhone({required String phone, required String country}) {
    _userModel.phoneNumber =
        phone.trim() == '' || phone.trim() == '+966' ? '' : phone.trim();
    _phoneCountry = country;
  }

  // phone login function
  void phoneLogin(
      {required String phone, required BuildContext context}) async {
    try {
      await _auth.verifyPhoneNumber(
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential).then((value) async {});
        },
        verificationFailed: (e) async {
          _loading = false;
          update();
          await showOkAlertDialog(
              context: context,
              title: 'error'.tr,
              message: getMessageFromErrorCode(errorMessage: e.code));
        },
        codeSent: (verificationId, resendToken) async {
          _loading = false;
          update();
          Get.to(() => OtpController(verificationId: verificationId));
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: getMessageFromErrorCode(errorMessage: e.code),
      );
    }
  }
}
