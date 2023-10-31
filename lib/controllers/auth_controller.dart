import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/otp_page/otp_controller.dart';
import 'package:cineverse/pages/pre_otp_page/pre_otp_controller.dart';
import 'package:cineverse/pages/view_controller.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phone_number/phone_number.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../utils/functions.dart';

class AuthController extends GetxController {
  final TargetPlatform platform;
  final UserModel _userModelStart;
  AuthController(this._userModelStart, {required this.platform});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> _user = Rxn<User>();

  User? get user => _user.value;

  UserModel _userModel = UserModel();
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

  final TextEditingController _otpController = TextEditingController();
  TextEditingController get otpController => _otpController;

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
    _userModel = _userModelStart;
    setListeners();
    //_auth.setSettings(appVerificationDisabledForTesting: true);
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
    _otpController.dispose();
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

  // when otp field is changed
  void onPtpChanged(
      {required String? code,
      required BuildContext context,
      required String verificationId}) {
    _otpController.text = code.toString();
    if (code!.length == 6) {
      FocusScope.of(context).unfocus();
      otpVerify(otp: code, verificationId: verificationId, context: context);
    }
  }

  // update the user model
  void userUpdate({required UserModel user}) {
    _userModel = user;
    DataPref()
        .setUser(_userModel)
        .then((value) => print("Operation is ===> $value"));
  }

  // when click back from otp page

  // switch the theme
  void themeSwich() {
    Get.changeTheme(Get.isDarkMode ? lightTheme : darkTheme);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarIconBrightness:
            Get.isDarkMode ? Brightness.dark : Brightness.light,
      ),
    );
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
    // check if we can get the phone number throught the plugin
    await SmsAutoFill().hint.then((value) async {
      if (value.toString() != 'null') {
        // start the loading animation
        _loading = true;
        update();
        _userModel.phoneNumber = value.toString();

        // phone number was chosen so excute phone login and go to otp page
        phoneAuth(phoneNumber: value.toString(), context: context);
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
        phone.trim() == '' || phone.trim() == '+966' || phone.trim().length <= 7
            ? ''
            : phone.trim();
    _phoneCountry = country;
  }

  // phone login function
  void phoneLogin({required BuildContext context}) async {
    FocusScope.of(context).unfocus();
    _loading = true;
    update();

    if (_userModel.phoneNumber == '' || _userModel.phoneNumber == null) {
      _loading = false;
      update();
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: 'enterphone'.tr,
      );
    } else {
      await phoneValid(
              phone: _userModel.phoneNumber.toString(), country: _phoneCountry)
          .then((value) async {
        if (value) {
          // start the phone authentication
          phoneAuth(
              phoneNumber: _userModel.phoneNumber.toString(), context: context);
        } else {
          // phone number is invalid
          _loading = false;
          update();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'badphone'.tr,
          );
        }
      });
    }
  }

  // phone authentication
  void phoneAuth({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {},
        verificationFailed: (e) async {
          print('== $e ==');
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
      print('=== ${e.code} ===');
      // ignore: use_build_context_synchronously
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: getMessageFromErrorCode(errorMessage: e.code),
      );
    }
  }

  // verify otp
  void otpVerify(
      {required String otp,
      required String verificationId,
      required BuildContext context}) async {
    _loading = true;
    update();
    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);

      await _auth.signInWithCredential(creds).then((user) async {
        await userExists(userId: user.user!.uid).then((value) async {
          if (value) {
            // old user , data already converted in the userExist function just save it locally , go to controller
            await FirebaseServices()
                .getCurrentUser(userId: user.user!.uid)
                .then(
              (value) async {
                _userModel =
                    UserModel.fromMap(value.data() as Map<String, dynamic>);
                await saveUserDataLocally(model: _userModel)
                    .then((saved) async {
                  if (saved) {
                    _loading = false;
                    Get.offAll(() => const ViewController());
                  } else {
                    _loading = false;
                    update();
                    await showOkAlertDialog(
                      context: context,
                      title: 'error'.tr,
                      message: 'firelogin'.tr,
                    );
                    Get.back();
                  }
                });
              },
            );
          } else {
            // new user , set the login state to info and the id and then save locally then stop loading and go to controller
            _userModel = UserModel(
                userName: '',
                email: '',
                onlinePicPath: '',
                localPicPath: '',
                userId: user.user!.uid,
                language: languageDev(),
                isError: false,
                messagingToken: '',
                state: LogState.info,
                gender: Gender.undecided,
                phoneNumber: _userModel.phoneNumber,
                birthday: '',
                errorMessage: '',
                method: LoginMethod.phone,
                avatarType: AvatarType.none,
                movieWatchList: [],
                showWatchList: [],
                favs: [],
                watching: [],
                theme: ChosenTheme.system,
                commentDislike: [],
                commentLike: []);
            await saveUserDataLocally(model: _userModel).then((saved) async {
              if (saved) {
                _loading = false;
                Get.offAll(() => const ViewController());
              } else {
                _loading = false;
                update();
                // ignore: use_build_context_synchronously
                await showOkAlertDialog(
                  context: context,
                  title: 'error'.tr,
                  message: 'firelogin'.tr,
                );
                Get.back();
              }
            }).onError((error, stackTrace) {});
          }
        }).onError((error, stackTrace) {});
      });
    } catch (e) {
      // wrong otp
      _loading = false;
      update();
      // ignore: use_build_context_synchronously
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: 'wrongotp'.tr,
      );
    }
  }

  // check if phone number is valid
  Future<bool> phoneValid(
      {required String phone, required String country}) async {
    RegionInfo region = RegionInfo(name: country, code: country, prefix: 2);

    return await PhoneNumberUtil().validate(phone, regionCode: region.code);
  }

  // check if the user exists
  Future<bool> userExists({required String userId}) async {
    var thing = await FirebaseServices().getCurrentUser(userId: userId);
    // if (thing.exists) {
    //   _userModel = UserModel.fromMap(thing.data() as Map<String, dynamic>);
    // }
    return thing.exists;
  }

  // save user data locally
  Future<bool> saveUserDataLocally({required UserModel model}) async {
    try {
      return await DataPref().setUser(model);
    } catch (e) {
      print('======>>>$e<<<====');
      return false;
    }
  }

  // upload user data to firestore
  Future<void> uploadUser({required UserModel model}) async {
    await FirebaseServices().addUsers(model);
  }

  // // uploading image to firebase storage
  // Future<String> uploadeImage(
  //     {required String id,
  //     required String file,
  //     required String fileName}) async {
  //   UploadTask? uploadTask;
  //   final String path = '$id/$fileName';
  //   final ref = FirebaseStorage.instance.ref().child(path);
  //   uploadTask = ref.putFile(File(file));
  //   final snapshot = await uploadTask.whenComplete(() => {});
  //   return await snapshot.ref.getDownloadURL();
  // }
}
