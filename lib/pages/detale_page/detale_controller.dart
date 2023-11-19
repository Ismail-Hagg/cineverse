import 'package:cineverse/controllers/movie_detale_controller.dart';
import 'package:cineverse/pages/detale_page/detale_desktop.dart';
import 'package:cineverse/pages/detale_page/detale_phone.dart';
import 'package:cineverse/pages/detale_page/detale_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DetalePageController extends StatelessWidget {
  const DetalePageController({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final MovieDetaleController controller = Get.put(MovieDetaleController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const DetalePagePhone()
        : width > phoneSize && width <= tabletSize
            ? const DetalePageTablet()
            : const DetalePageDesktop();
  }
}
