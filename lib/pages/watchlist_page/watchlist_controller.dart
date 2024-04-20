import 'package:cineverse/controllers/wachlist_controller.dart';
import 'package:cineverse/pages/watchlist_page/watchlist_desktop.dart';
import 'package:cineverse/pages/watchlist_page/watchlist_phone.dart';
import 'package:cineverse/pages/watchlist_page/watchlist_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WatchlistViewController extends StatelessWidget {
  const WatchlistViewController({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WatchlistController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const WatchlistPhone()
        : width > phoneSize && width <= tabletSize
            ? const WatchlistTablet()
            : const WatchlistDesktop();
  }
}
