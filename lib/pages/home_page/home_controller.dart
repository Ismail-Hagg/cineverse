import 'package:cineverse/pages/home_page/home_desktop.dart';
import 'package:cineverse/pages/home_page/home_phone.dart';
import 'package:cineverse/pages/home_page/home_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/material.dart';

class HomePageController extends StatelessWidget {
  const HomePageController({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const HomePhone()
        : width > phoneSize && width <= tabletSize
            ? const HomeTablet()
            : const HomeDesktop();
  }
}
