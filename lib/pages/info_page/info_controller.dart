import 'package:cineverse/pages/info_page/info_desktop.dart';
import 'package:cineverse/pages/info_page/info_phone.dart';
import 'package:cineverse/pages/info_page/info_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/material.dart';

class InfoController extends StatelessWidget {
  const InfoController({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const InfoPhone()
        : width > phoneSize && width <= tabletSize
            ? const InfoTablet()
            : const InfoDesktop();
  }
}
