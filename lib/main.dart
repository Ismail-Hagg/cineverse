import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/firebase_options.dart';
import 'package:cineverse/local_storage/user_data.dart';
import 'package:cineverse/models/user_model.dart';
import 'package:cineverse/pages/view_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
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
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarIconBrightness: user.theme == ChosenTheme.light
              ? Brightness.dark
              : Brightness.light,
        ),
      );
      runApp(
        MyApp(
          theme: user.theme ?? ChosenTheme.system,
          language: Locale(
              user.language!.substring(0, 2), user.language!.substring(3, 5)),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  final ChosenTheme theme;
  final Locale language;
  const MyApp({super.key, required this.language, required this.theme});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cineverse',
      locale: language,
      translations: Translation(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: theme == ChosenTheme.system
          ? ThemeMode.system
          : theme == ChosenTheme.light
              ? ThemeMode.light
              : ThemeMode.dark,
      home: const ViewController(),
    );
  }
}
