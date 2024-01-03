import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/info_page/info_controller.dart';
import 'package:cineverse/pages/otp_page/otp_controller.dart';
import 'package:cineverse/pages/pre_otp_page/pre_otp_controller.dart';
import 'package:cineverse/pages/view_controller.dart';
import 'package:cineverse/services/firebase_service.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
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
    FieldType.signupUser: FocusNode(),
    FieldType.signupBirth: FocusNode()
  };

  final Map<FieldType, bool> _flips = {
    FieldType.loginEmail: false,
    FieldType.loginPass: false,
    FieldType.signupEmail: false,
    FieldType.signupPass: false,
    FieldType.signupUser: false,
    FieldType.signupBirth: false
  };

  final Map<FieldType, TextEditingController> _txtControllers = {
    FieldType.loginEmail: TextEditingController(),
    FieldType.loginPass: TextEditingController(),
    FieldType.signupEmail: TextEditingController(),
    FieldType.signupPass: TextEditingController(),
    FieldType.signupUser: TextEditingController(),
    FieldType.signupBirth: TextEditingController()
  };

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
    _userModel = _userModelStart;
    setListeners();
    _auth.setLanguageCode(_userModel.language!.substring(0, 2));
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
    _nodes.forEach(
      (key, value) {
        value.addListener(
          () {
            if (value.hasFocus) {
              _flips[key] = true;
              update();
            } else {
              _flips[key] = false;
              update();
            }
          },
        );
      },
    );
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
  void userUpdate(
      {required String userId, required Map<String, dynamic> map}) async {
    await FirebaseServices().userUpdate(userId: userId, map: map);
  }

  // switch the theme
  void themeSwich() async {
    if (Get.isDarkMode) {
      _userModel.theme = ChosenTheme.light;
      Get.changeTheme(lightTheme);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
        ),
      );
      await saveUserDataLocally(model: _userModel).then((value) {
        userUpdate(
            userId: _userModel.userId.toString(),
            map: {'theme': _userModel.theme.toString()});
      });
    } else {
      _userModel.theme = ChosenTheme.dark;
      Get.changeTheme(darkTheme);
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
        ),
      );
      await saveUserDataLocally(model: _userModel).then((value) {
        userUpdate(
            userId: _userModel.userId.toString(),
            map: {'theme': _userModel.theme.toString()});
      });
    }

    update();
  }

  // logout
  void signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
    await DataPref().deleteUser();
    update();
    _txtControllers.forEach((key, value) {
      value.clear();
    });
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
            // old user
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
                    // update the theme
                    themeDecide(theme: _userModel.theme as ChosenTheme);
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
                following: [],
                follwers: [],
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
            }).onError((error, stackTrace) async {
              _loading = false;
              update();
              Get.back();
              await showOkAlertDialog(
                context: context,
                title: 'error'.tr,
                message: 'firelogin'.tr,
              );
            });
          }
        }).onError((error, stackTrace) async {
          _loading = false;
          update();
          Get.back();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'firelogin'.tr,
          );
        });
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
    return thing.exists;
  }

  // save user data locally
  Future<bool> saveUserDataLocally({required UserModel model}) async {
    try {
      return await DataPref().setUser(model);
    } catch (e) {
      return false;
    }
  }

  // google sign in method
  void googleSignIn({required BuildContext context}) async {
    _loading = true;
    update();
    await GoogleSignIn().signIn().then(
      (value) async {
        if (value != null) {
          try {
            final GoogleSignInAuthentication gAuth = await value.authentication;

            final credential = GoogleAuthProvider.credential(
                accessToken: gAuth.accessToken, idToken: gAuth.idToken);
            await _auth.signInWithCredential(credential).then(
              (user) async {
                await userExists(userId: user.user!.uid).then(
                  (val) async {
                    if (val) {
                      // old user
                      await FirebaseServices()
                          .getCurrentUser(userId: user.user!.uid)
                          .then(
                        (value) async {
                          _userModel = UserModel.fromMap(
                              value.data() as Map<String, dynamic>);
                          if (_userModel.avatarType == AvatarType.online &&
                              _userModel.onlinePicPath != user.user!.photoURL) {
                            _userModel.onlinePicPath = user.user!.photoURL;
                          }
                          await saveUserDataLocally(model: _userModel)
                              .then((saved) async {
                            if (saved) {
                              _loading = false;
                              // update the theme
                              themeDecide(
                                  theme: _userModel.theme as ChosenTheme);
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
                      // new user

                      _userModel = UserModel(
                          userName: user.user!.displayName ?? '',
                          email: user.user!.email ?? '',
                          onlinePicPath: user.user!.photoURL ?? '',
                          localPicPath: '',
                          userId: user.user!.uid,
                          language: languageDev(),
                          isError: false,
                          messagingToken: '',
                          state: LogState.info,
                          gender: Gender.undecided,
                          phoneNumber: user.user!.phoneNumber ?? '',
                          birthday: '',
                          errorMessage: '',
                          method: LoginMethod.google,
                          avatarType: AvatarType.online,
                          movieWatchList: [],
                          showWatchList: [],
                          following: [],
                          follwers: [],
                          favs: [],
                          watching: [],
                          theme: ChosenTheme.system,
                          commentDislike: [],
                          commentLike: []);
                      await saveUserDataLocally(model: _userModel)
                          .then((saved) async {
                        if (saved) {
                          _loading = false;
                          _txtControllers[FieldType.signupUser]!.text =
                              _userModel.userName.toString();
                          _txtControllers[FieldType.signupEmail]!.text =
                              _userModel.email.toString();
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
                      }).onError((error, stackTrace) async {
                        _loading = false;
                        update();
                        Get.back();
                        await showOkAlertDialog(
                          context: context,
                          title: 'error'.tr,
                          message: 'firelogin'.tr,
                        );
                      });
                    }
                  },
                );
              },
            );
          } on FirebaseAuthException catch (e) {
            _loading = false;
            update();
            // ignore: use_build_context_synchronously
            await showOkAlertDialog(
              context: context,
              title: 'error'.tr,
              message: getMessageFromErrorCode(errorMessage: e.code),
            );
          } catch (e) {
            _loading = false;
            update();
            // ignore: use_build_context_synchronously
            await showOkAlertDialog(
              context: context,
              title: 'error'.tr,
              message: getMessageFromErrorCode(errorMessage: e.toString()),
            );
          }
        } else {
          _loading = false;
          update();
        }
      },
    );
  }

  // login with email and password
  void emailLogin({required BuildContext context}) async {
    String email = _txtControllers[FieldType.loginEmail]!.text;
    String password = _txtControllers[FieldType.loginPass]!.text;
    if (email.trim() != '' && password.trim() != '') {
      unfocusNodes();
      _loading = true;
      update();

      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((user) async {
          FirebaseServices()
              .getCurrentUser(userId: user.user!.uid.toString())
              .then((value) {
            _userModel =
                UserModel.fromMap(value.data() as Map<String, dynamic>);
            saveUserDataLocally(model: _userModel).then((done) async {
              if (done) {
                _loading = false;
                // update the theme
                themeDecide(theme: _userModel.theme as ChosenTheme);
                update();
                Get.offAll(() => const ViewController());
              } else {
                _loading = false;
                update();
                await showOkAlertDialog(
                  context: context,
                  title: 'error'.tr,
                  message: 'firelogin'.tr,
                );
              }
            });
          });
        });
      } on FirebaseAuthException catch (e) {
        _loading = false;
        update();
        // ignore: use_build_context_synchronously
        await showOkAlertDialog(
          context: context,
          title: 'error'.tr,
          message: getMessageFromErrorCode(errorMessage: e.code),
        );
      } catch (e) {
        _loading = false;
        update();
        // ignore: use_build_context_synchronously
        await showOkAlertDialog(
          context: context,
          title: 'error'.tr,
          message: getMessageFromErrorCode(errorMessage: e.toString()),
        );
      }
    }
  }

  // go to info page for email new account
  void goToEmail() {
    _userModel = UserModel(
        userName: '',
        email: '',
        onlinePicPath: '',
        localPicPath: '',
        userId: '',
        language: languageDev(),
        isError: false,
        messagingToken: '',
        state: LogState.info,
        gender: Gender.undecided,
        phoneNumber: '',
        birthday: '',
        errorMessage: '',
        method: LoginMethod.email,
        avatarType: AvatarType.none,
        movieWatchList: [],
        showWatchList: [],
        favs: [],
        watching: [],
        following: [],
        follwers: [],
        theme: ChosenTheme.system,
        commentDislike: [],
        commentLike: []);

    Get.to(() => const InfoController());
  }

  // back from info page
  void infoBack() {
    if (_userModel.method == LoginMethod.email) {
      _userModel.state = LogState.none;
      _userModel.method = LoginMethod.none;
      Get.back();
    } else {
      signOut();
    }
  }

  // select pic from device
  void selectPic({required bool save}) async {
    await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']).then((value) async {
      if (value != null) {
        _userModel.localPicPath = value.files.single.path.toString();
        _userModel.avatarType = AvatarType.local;
        if (save) {
          await saveUserDataLocally(model: _userModel);
        }
        update();
      }
    });
  }

  // delete selected picture
  void deletePic({required bool save}) async {
    _userModel.localPicPath = '';
    _userModel.avatarType = AvatarType.none;
    if (save) {
      await saveUserDataLocally(model: _userModel);
    }
    update();
  }

  // finish logging in from info page
  void afterInfo({required BuildContext context}) async {
    String email = _txtControllers[FieldType.signupEmail]!.text;
    String user = _txtControllers[FieldType.signupUser]!.text;
    String birth = _userModel.birthday.toString();
    Gender gender = _userModel.gender as Gender;

    switch (_userModel.method) {
      case LoginMethod.email:
        emailSignup(context: context);
        break;

      case LoginMethod.google:
        _loading = true;
        update();
        if (email.trim() != '' &&
            user.trim() != '' &&
            birth != '' &&
            gender != Gender.undecided) {
          _userModel.userName = user;
          _userModel.birthday = birth;
          _userModel.email = email;
          _userModel.gender = gender;
          _userModel.state = LogState.full;
          await saveUserDataLocally(model: _userModel).then((saved) async {
            // data saves , redirect to home page and updoad user data to backend
            _loading = false;
            update();
            Get.offAll(() => const ViewController());
            await uploadUser(model: _userModel);
          });
        } else {
          _loading = false;
          update();
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'complete'.tr,
          );
        }
        break;

      case LoginMethod.phone:
        _loading = true;
        update();
        if (user.trim() != '' && birth != '' && gender != Gender.undecided) {
          _userModel.userName = user;
          _userModel.birthday = birth;
          _userModel.gender = gender;
          _userModel.state = LogState.full;
          await saveUserDataLocally(model: _userModel).then((saved) async {
            // data saves , redirect to home page and updoad user data to backend
            _loading = false;
            update();
            Get.offAll(() => const ViewController());
            await uploadUser(model: _userModel);
          });
        } else {
          _loading = false;
          update();
          // ignore: use_build_context_synchronously
          await showOkAlertDialog(
            context: context,
            title: 'error'.tr,
            message: 'complete'.tr,
          );
        }
        break;
      default:
    }
  }

  // login with email and password
  void emailSignup({
    required BuildContext context,
  }) async {
    String email = _txtControllers[FieldType.signupEmail]!.text;
    String password = _txtControllers[FieldType.signupPass]!.text;
    String localUser = _txtControllers[FieldType.signupUser]!.text;
    String birth = _userModel.birthday.toString();
    Gender gender = _userModel.gender as Gender;

    if (email.trim() != '' &&
        password.trim() != '' &&
        localUser.trim() != '' &&
        birth.trim() != '' &&
        gender != Gender.undecided) {
      _loading = true;
      update();
      unfocusNodes();
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then(
          (user) async {
            // new user

            _userModel = UserModel(
                userName: localUser.trim(),
                email: user.user!.email ?? '',
                onlinePicPath: user.user!.photoURL ?? '',
                localPicPath: _userModel.localPicPath,
                userId: user.user!.uid,
                language: languageDev(),
                isError: false,
                messagingToken: '',
                state: LogState.full,
                gender: _userModel.gender,
                phoneNumber: user.user!.phoneNumber ?? '',
                birthday: _userModel.birthday,
                errorMessage: '',
                method: LoginMethod.email,
                avatarType: _userModel.avatarType,
                movieWatchList: [],
                showWatchList: [],
                favs: [],
                following: [],
                follwers: [],
                watching: [],
                theme: ChosenTheme.system,
                commentDislike: [],
                commentLike: []);
            await saveUserDataLocally(model: _userModel).then((saved) async {
              _loading = false;
              update();
              Get.offAll(() => const ViewController());
              await uploadUser(model: _userModel);
            }).onError((error, stackTrace) async {
              _loading = false;
              update();
              Get.back();
              await showOkAlertDialog(
                context: context,
                title: 'error'.tr,
                message: error.toString(),
              );
              signOut();
            });
          },
        );
      } on FirebaseAuthException catch (e) {
        _loading = false;
        update();
        // ignore: use_build_context_synchronously
        await showOkAlertDialog(
          context: context,
          title: 'error'.tr,
          message: getMessageFromErrorCode(errorMessage: e.code),
        );
      } catch (e) {
        _loading = false;
        update();
        // ignore: use_build_context_synchronously
        await showOkAlertDialog(
          context: context,
          title: 'error'.tr,
          message: getMessageFromErrorCode(errorMessage: e.toString()),
        );
      }
    } else {
      _loading = false;
      update();
      await showOkAlertDialog(
        context: context,
        title: 'error'.tr,
        message: 'complete'.tr,
      );
    }
  }

  // upload user data to firestore
  Future<void> uploadUser({required UserModel model}) async {
    await FirebaseServices().addUsers(model);
  }

  // date picker platform
  void datePicker({
    required BuildContext context,
    required Widget iosDate,
  }) async {
    if (platform == TargetPlatform.iOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return iosDate;
          });
    } else {
      final DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(3000));
      if (dateTime != null) {
        setBirth(birth: dateTime, clear: false);
      }
    }
  }

  // set birth date in user model
  void setBirth({required DateTime birth, required bool clear}) {
    if (clear) {
      _userModel.birthday = '';
      _txtControllers[FieldType.signupBirth]!.clear();
    } else {
      String time = DateFormat('yyyy-MM-dd').format(birth);
      _userModel.birthday = time;
      _txtControllers[FieldType.signupBirth]!.text = time;
    }
    update();
  }

  // set gender in model
  void setGender({required Gender gender}) {
    _userModel.gender = gender;
    update();
  }

  // change theme on login
  void themeDecide({required ChosenTheme theme}) {
    final bool localThemeDark = Get.isDarkMode;
    final bool userTheme = theme == ChosenTheme.dark;
    if (localThemeDark != userTheme) {
      Get.changeTheme(userTheme ? darkTheme : lightTheme);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarIconBrightness:
              userTheme ? Brightness.light : Brightness.dark,
        ),
      );
    }
    if (Get.deviceLocale.toString().substring(0, 2) !=
        _userModel.language.toString().substring(0, 2)) {
      Get.updateLocale(Locale(_userModel.language.toString().substring(0, 2),
          _userModel.language.toString().substring(3, 5)));
    }
  }
}
