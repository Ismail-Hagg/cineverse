import 'package:cineverse/pages/favorites_page/favourites_desktop.dart';
import 'package:cineverse/pages/favorites_page/favourites_phone.dart';
import 'package:cineverse/pages/favorites_page/favourites_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class FavouritesController extends StatelessWidget {
  const FavouritesController({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const FavouritesPhone()
        : width > phoneSize && width <= tabletSize
            ? const FavouritesTablet()
            : const FavouritesDesktop();
  }
}
