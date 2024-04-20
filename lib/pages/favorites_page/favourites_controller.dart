import 'package:cineverse/controllers/favorites_controller.dart';
import 'package:cineverse/pages/favorites_page/favourites_desktop.dart';
import 'package:cineverse/pages/favorites_page/favourites_phone.dart';
import 'package:cineverse/pages/favorites_page/favourites_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FavouritesViewController extends StatelessWidget {
  const FavouritesViewController({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(FavoritesController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const FavouritesPhone()
        : width > phoneSize && width <= tabletSize
            ? const FavouritesTablet()
            : const FavouritesDesktop();
  }
}
