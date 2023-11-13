import 'package:cineverse/pages/episode_keeping_page/keeping_desktop.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_phone.dart';
import 'package:cineverse/pages/episode_keeping_page/keeping_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class KeepingController extends StatelessWidget {
  const KeepingController({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const KeepingPhone()
        : width > phoneSize && width <= tabletSize
            ? const KeepingTablet()
            : const KeepingDesktop();
  }
}
