import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/firebase_options.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/view_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:cineverse/utils/translation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (defaultTargetPlatform == TargetPlatform.macOS) {
    // set minimum height and width
    // minimum is the tablet view
  } else {
    // lock the orientation
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  await DataPref().getUserData().then(
    (user) {
      Get.put(
        AuthController(user, platform: defaultTargetPlatform),
      );
      runApp(
        MyApp(
          language: language(user: user),
        ),
      );
    },
  );
}

Locale language({required UserModel user}) {
  return user.isError == true || user.language == ''
      ? Locale(
          languageDev().substring(0, 2),
          languageDev().substring(3, 5),
        )
      : Locale(
          user.language.toString().substring(0, 2),
          user.language.toString().substring(3, 5),
        );
}

class MyApp extends StatelessWidget {
  final Locale language;
  const MyApp({super.key, required this.language});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cineverse',
      translations: Translation(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const ViewController(),
    );
  }
}
