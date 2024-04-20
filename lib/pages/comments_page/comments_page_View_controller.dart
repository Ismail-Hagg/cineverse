// ignore_for_file: file_names

import 'package:cineverse/pages/comments_page/comments_desktop.dart';
import 'package:cineverse/pages/comments_page/comments_phone.dart';
import 'package:cineverse/pages/comments_page/comments_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/material.dart';

class CommentsPageViewController extends StatelessWidget {
  const CommentsPageViewController({super.key});

  @override
  Widget build(BuildContext context) {
    //CommentsPageController controller = Get.put(CommentsPageController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const CommentsPagePhone()
        : width > phoneSize && width <= tabletSize
            ? const CommentsPageTablet()
            : const CommentsPageDesktop();
  }
}
