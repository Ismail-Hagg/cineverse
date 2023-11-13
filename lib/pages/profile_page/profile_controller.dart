import 'package:cineverse/pages/profile_page/profile_desktop.dart';
import 'package:cineverse/pages/profile_page/profile_phone.dart';
import 'package:cineverse/pages/profile_page/profile_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class ProfileController extends StatelessWidget {
  const ProfileController({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const ProfilePhone()
        : width > phoneSize && width <= tabletSize
            ? const ProfileTablet()
            : const ProfileDesktop();
  }
}
