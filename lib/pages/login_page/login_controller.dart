import 'package:cineverse/pages/login_page/login_desktop.dart';
import 'package:cineverse/pages/login_page/login_phone.dart';
import 'package:cineverse/pages/login_page/login_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/material.dart';

class LoginController extends StatelessWidget {
  const LoginController({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? LoginPhone()
        : width > phoneSize && width <= tabletSize
            ? const LoginTablet()
            : const LoginDesktop();
  }
}
