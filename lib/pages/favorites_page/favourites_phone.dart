import 'package:cineverse/controllers/favorites_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class FavouritesPhone extends StatelessWidget {
  const FavouritesPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoritesController>(
      init: Get.find<FavoritesController>(),
      builder: (controller) => GestureDetector(
        onTap: () => controller.unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: CustomText(
              text: 'favourite'.tr,
              color: Theme.of(context).colorScheme.primary,
            ),
            centerTitle: false,
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            actions: [
              // count
              Center(
                child: controller.loading
                    ? controller.isIos
                        ? CupertinoActivityIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          )
                    : CustomText(
                        text: controller.query.trim() != '' &&
                                    controller.searched.isEmpty ||
                                controller.genreFilter == true &&
                                    controller.afterGenre.isEmpty &&
                                    controller.genresFiltered.isNotEmpty
                            ? '0'
                            : controller.search == true &&
                                    controller.searched.isNotEmpty
                                ? controller.searched.length.toString()
                                : controller.genreFilter == true &&
                                        controller.afterGenre.isNotEmpty
                                    ? controller.afterGenre.length.toString()
                                    : controller.lst.length.toString(),
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              ),
              // search
              controller.isIos
                  ? CupertinoButton(
                      onPressed: () => controller.openSearch(),
                      child: FaIcon(
                        controller.search
                            ? FontAwesomeIcons.magnifyingGlassMinus
                            : FontAwesomeIcons.magnifyingGlass,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    )
                  : IconButton(
                      splashRadius: 15,
                      onPressed: () => controller.openSearch(),
                      icon: FaIcon(
                        controller.search
                            ? FontAwesomeIcons.magnifyingGlassMinus
                            : FontAwesomeIcons.magnifyingGlass,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
              // go to random one
              controller.isIos
                  ? CupertinoButton(
                      onPressed: () => controller.randomMovie(),
                      child: FaIcon(
                        FontAwesomeIcons.shuffle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    )
                  : IconButton(
                      splashRadius: 15,
                      onPressed: () => controller.randomMovie(),
                      icon: FaIcon(
                        FontAwesomeIcons.shuffle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
              // filter
              controller.isIos
                  ? CupertinoButton(
                      onPressed: () => controller.openGenreFilter(),
                      child: FaIcon(
                        controller.genreFilter
                            ? FontAwesomeIcons.filterCircleXmark
                            : FontAwesomeIcons.filter,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    )
                  : IconButton(
                      splashRadius: 15,
                      onPressed: () => controller.openGenreFilter(),
                      icon: FaIcon(
                        controller.genreFilter
                            ? FontAwesomeIcons.filterCircleXmark
                            : FontAwesomeIcons.filter,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
              // ascending descending
              controller.isIos
                  ? CupertinoButton(
                      onPressed: () => controller.orderFlip(),
                      child: FaIcon(
                        controller.newest
                            ? FontAwesomeIcons.arrowUpWideShort
                            : FontAwesomeIcons.arrowDownWideShort,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    )
                  : IconButton(
                      splashRadius: 15,
                      onPressed: () => controller.orderFlip(),
                      icon: FaIcon(
                        controller.newest
                            ? FontAwesomeIcons.arrowUpWideShort
                            : FontAwesomeIcons.arrowDownWideShort,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    )
            ],
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              var width = constraints.maxWidth;

              return controller.loading
                  ? Center(
                      child: SizedBox(
                        width: width * 0.1,
                        height: width * 0.1,
                        child: FittedBox(
                          child: controller.isIos
                              ? CupertinoActivityIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Column(
                          children: [
                            if (controller.genreFilter) ...[
                              SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    controller.genres.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      child: ChoiceChip(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          elevation: controller.genresFiltered
                                                  .contains(
                                                      controller.genres[index])
                                              ? 5
                                              : 0,
                                          selectedColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          onSelected: (value) => controller.addGenre(
                                              contains: controller
                                                  .genresFiltered
                                                  .contains(
                                                      controller.genres[index]),
                                              genre: controller.genres[index]),
                                          label: CustomText(
                                            text: controller.genres[index],
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                          ),
                                          selected: controller.genresFiltered
                                              .contains(
                                                  controller.genres[index])),
                                    ),
                                  ),
                                ),
                              )
                            ],
                            if (controller.search) ...[
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 12, left: 12, bottom: 16),
                                child: LoginInput(
                                    focusNode: controller.focusNode,
                                    change: (query) =>
                                        controller.searching(input: query),
                                    hintNoLable: 'localsearch'.tr,
                                    controller: controller.txtController,
                                    suffex: controller.isIos
                                        ? CupertinoButton(
                                            onPressed: () =>
                                                controller.clearSearch(),
                                            child: FaIcon(
                                              FontAwesomeIcons.xmark,
                                              color:
                                                  controller.query.trim() != ''
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                              size: 20,
                                            ),
                                          )
                                        : IconButton(
                                            splashRadius: 15,
                                            onPressed: () =>
                                                controller.clearSearch(),
                                            icon: FaIcon(
                                              FontAwesomeIcons.xmark,
                                              color:
                                                  controller.query.trim() != ''
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                      : Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                              size: 20,
                                            ),
                                          ),
                                    height: width * 0.125,
                                    width: width,
                                    obscure: false,
                                    isSearch: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: (width * 0.1) / 2),
                                    isSelected: controller.focus),
                              )
                            ],
                            controller.query.trim() != '' &&
                                        controller.searched.isEmpty ||
                                    controller.genreFilter == true &&
                                        controller.afterGenre.isEmpty &&
                                        controller.genresFiltered.isNotEmpty
                                ? SizedBox(
                                    height: width * 0.8,
                                    width: width * 0.8,
                                    child: Center(
                                      child: CustomText(
                                        text: 'res'.tr,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: List.generate(
                                      controller.search == true &&
                                              controller.searched.isNotEmpty
                                          ? controller.searched.length
                                          : controller.genreFilter == true &&
                                                  controller
                                                      .afterGenre.isNotEmpty
                                              ? controller.afterGenre.length
                                              : controller.lst.length,
                                      (index) => controller.isIos
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: CupertinoListTile(
                                                trailing: controller.isIos
                                                    ? CupertinoButton(
                                                        onPressed: () =>
                                                            controller
                                                                .favDelete(
                                                                    index:
                                                                        index),
                                                        child: FaIcon(
                                                          FontAwesomeIcons
                                                              .trashCan,
                                                          size: width * 0.045,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      )
                                                    : IconButton(
                                                        onPressed: () =>
                                                            controller
                                                                .favDelete(
                                                                    index:
                                                                        index),
                                                        icon: FaIcon(
                                                          FontAwesomeIcons
                                                              .trashCan,
                                                          size: width * 0.045,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                backgroundColorActivated: Colors
                                                    .grey
                                                    .withOpacity(0.3),
                                                onTap: () => controller
                                                    .navToDetale(index: index),
                                                leadingSize: width * 0.15,
                                                leading: ImageNetWork(
                                                    border: Colors.transparent,
                                                    link: controller.search ==
                                                                true &&
                                                            controller.searched
                                                                .isNotEmpty
                                                        ? imagebase +
                                                            controller
                                                                .searched[index]
                                                                .posterPath
                                                                .toString()
                                                        : controller.genreFilter ==
                                                                    true &&
                                                                controller
                                                                    .afterGenre
                                                                    .isNotEmpty
                                                            ? imagebase +
                                                                controller
                                                                    .afterGenre[
                                                                        index]
                                                                    .posterPath
                                                                    .toString()
                                                            : imagebase +
                                                                controller
                                                                    .lst[index]
                                                                    .posterPath
                                                                    .toString(),
                                                    width: width * 0.2,
                                                    height: width * 0.2),
                                                title: CustomText(
                                                  maxline: 2,
                                                  text: controller.search ==
                                                              true &&
                                                          controller.searched
                                                              .isNotEmpty
                                                      ? controller
                                                          .searched[index].title
                                                          .toString()
                                                      : controller.genreFilter ==
                                                                  true &&
                                                              controller
                                                                  .afterGenre
                                                                  .isNotEmpty
                                                          ? controller
                                                              .afterGenre[index]
                                                              .title
                                                              .toString()
                                                          : controller
                                                              .lst[index].title
                                                              .toString(),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ListTile(
                                                minLeadingWidth: width * 0.15,
                                                onTap: () => controller
                                                    .navToDetale(index: index),
                                                leading: ImageNetWork(
                                                    border: Colors.transparent,
                                                    link: controller.search ==
                                                                true &&
                                                            controller.searched
                                                                .isNotEmpty
                                                        ? imagebase +
                                                            controller
                                                                .searched[index]
                                                                .posterPath
                                                                .toString()
                                                        : controller.genreFilter ==
                                                                    true &&
                                                                controller
                                                                    .afterGenre
                                                                    .isNotEmpty
                                                            ? controller
                                                                .afterGenre[
                                                                    index]
                                                                .posterPath
                                                                .toString()
                                                            : imagebase +
                                                                controller
                                                                    .lst[index]
                                                                    .posterPath
                                                                    .toString(),
                                                    width: width * 0.15,
                                                    height: width * 0.15),
                                                title: CustomText(
                                                  maxline: 2,
                                                  text: controller.search ==
                                                              true &&
                                                          controller.searched
                                                              .isNotEmpty
                                                      ? controller
                                                          .searched[index].title
                                                          .toString()
                                                      : controller.genreFilter ==
                                                                  true &&
                                                              controller
                                                                  .afterGenre
                                                                  .isNotEmpty
                                                          ? controller
                                                              .afterGenre[index]
                                                              .title
                                                              .toString()
                                                          : controller
                                                              .lst[index].title
                                                              .toString(),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
