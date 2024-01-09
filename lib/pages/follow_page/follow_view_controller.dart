import 'package:cineverse/pages/follow_page/follow_desktop.dart';
import 'package:cineverse/pages/follow_page/follow_phone.dart';
import 'package:cineverse/pages/follow_page/follow_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/material.dart';

class FollowViewControll extends StatelessWidget {
  const FollowViewControll({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const FollowPhone()
        : width > phoneSize && width <= tabletSize
            ? const FollowTablet()
            : const FollowDesktop();
  }
}
