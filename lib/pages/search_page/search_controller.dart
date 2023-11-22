import 'package:cineverse/controllers/search_controller.dart';
import 'package:cineverse/pages/search_page/search_desktop.dart';
import 'package:cineverse/pages/search_page/search_phone.dart';
import 'package:cineverse/pages/search_page/search_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchViewController extends StatelessWidget {
  const SearchViewController({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final SearchMoreController controller = Get.put(SearchMoreController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const SearchPhone()
        : width > phoneSize && width <= tabletSize
            ? const SearchTablet()
            : const SearchDesktop();
  }
}
