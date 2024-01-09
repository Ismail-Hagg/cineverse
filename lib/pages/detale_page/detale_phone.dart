import 'package:carousel_slider/carousel_slider.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/result_details_model.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:cineverse/widgets/comment_widget.dart';
import 'package:cineverse/widgets/content_scrolling.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:cineverse/widgets/menu_widget.dart';
import 'package:cineverse/widgets/movie_widget.dart';
import 'package:cineverse/widgets/square_button.dart';
import 'package:cineverse/widgets/tab_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';

import '../../controllers/movie_detale_controller.dart';

class DetalePagePhone extends StatelessWidget {
  const DetalePagePhone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    bool isIos = authController.platform == TargetPlatform.iOS;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onBackground,
      body: GetBuilder<MovieDetaleController>(
        init: Get.find<MovieDetaleController>(),
        builder: (controller) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var height = constraints.maxHeight;
            var width = constraints.maxWidth;
            return GestureDetector(
              onTap: () => controller.focusNode.unfocus(),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: width * 0.92,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: width,
                            height: width * 0.85,
                            child: GestureDetector(
                              onTap: () => controller.getImages(
                                  height: width,
                                  width: width,
                                  isActor: false,
                                  id: controller.detales.id.toString(),
                                  content: GetBuilder<MovieDetaleController>(
                                    init: Get.find<MovieDetaleController>(),
                                    builder: (build) => Center(
                                      child: controller.imagesCounter == 1
                                          ? isIos
                                              ? CupertinoActivityIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  radius: width * 0.05,
                                                )
                                              : CircularProgressIndicator(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                )
                                          : controller.imageModel.isError ==
                                                  false
                                              ? CarouselSlider.builder(
                                                  options: CarouselOptions(
                                                      height: height * 0.6,
                                                      enlargeCenterPage: true),
                                                  itemCount: controller
                                                      .imageModel.links!.length,
                                                  itemBuilder: (context, index,
                                                      realIndex) {
                                                    return ImageNetWork(
                                                      link: imagebase +
                                                          controller.imageModel
                                                              .links![index],
                                                      height: height * 0.95,
                                                      width: width * 0.8,
                                                      border:
                                                          Colors.transparent,
                                                      shadow: false,
                                                    );
                                                  },
                                                )
                                              : isIos
                                                  ? CupertinoAlertDialog(
                                                      title: Text('noimage'.tr),
                                                      actions: [
                                                        CupertinoDialogAction(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child: Text(
                                                              'ok'.tr,
                                                            ))
                                                      ],
                                                    )
                                                  : AlertDialog(
                                                      title: Text('noimage'.tr),
                                                      actions: [
                                                        TextButton(
                                                          style: TextButton
                                                              .styleFrom(
                                                            foregroundColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .primary,
                                                          ),
                                                          child:
                                                              Text("answer".tr),
                                                          onPressed: () async =>
                                                              {
                                                            Get.back(),
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                    ),
                                  ),
                                  isIos: true),
                              child: ShapeOfView(
                                elevation: 10,
                                shape: ArcShape(
                                    direction: ArcDirection.Outside,
                                    height: 50,
                                    position: ArcPosition.Bottom),
                                child: ImageNetWork(
                                    border: Colors.transparent,
                                    link: imagebase +
                                        controller.detales.posterPath
                                            .toString(),
                                    width: width,
                                    height: height),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: RawMaterialButton(
                              padding: const EdgeInsets.all(10),
                              elevation: 6,
                              onPressed: () {
                                controller.trailerButton(
                                    model: controller.detales.trailer,
                                    content: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SingleChildScrollView(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          child: Column(
                                            children: List.generate(
                                              controller.detales.trailer != null
                                                  ? controller.detales.trailer!
                                                      .results!.length
                                                  : 0,
                                              (index) {
                                                return Material(
                                                  child: ListTile(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            url:
                                                                'https://www.youtube.com/watch?v=${controller.detales.trailer!.results![index].key}',
                                                            context: context),
                                                    title: CustomText(
                                                        maxline: 2,
                                                        flow: TextOverflow
                                                            .ellipsis,
                                                        text: controller
                                                            .detales
                                                            .trailer!
                                                            .results![index]
                                                            .name
                                                            .toString()),
                                                    subtitle: CustomText(
                                                        text: controller
                                                            .detales
                                                            .trailer!
                                                            .results![index]
                                                            .type
                                                            .toString()),
                                                    leading: ImageNetWork(
                                                        border:
                                                            Colors.transparent,
                                                        fit: BoxFit.cover,
                                                        link:
                                                            'https://img.youtube.com/vi/${controller.detales.trailer!.results![index].key.toString()}/0.jpg',
                                                        width: width * 0.2,
                                                        height: width * 0.2),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    context: context);
                              },
                              shape: const CircleBorder(),
                              fillColor: whiteColor,
                              child: controller.loading == 1
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    )
                                  : Icon(Icons.play_arrow,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: width * 0.13),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  controller.detales.isShow == true
                                      ? Menu(
                                          ios: isIos,
                                          titles: [
                                            "addtowatch".tr,
                                            "addkeep".tr
                                          ],
                                          funcs: [
                                            () => {
                                                  isIos ? Get.back() : null,
                                                  controller.favWatch(
                                                      path: FirebaseUserPaths
                                                          .watchlist,
                                                      id: controller.detales.id
                                                          .toString(),
                                                      context: context)
                                                },
                                            () => controller.addKeeping(
                                                isIos: isIos, context: context)
                                          ],
                                          child: Icon(Icons.add,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: width * 0.08),
                                        )
                                      : IconButton(
                                          splashRadius: 15,
                                          icon: Icon(Icons.add,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: width * 0.08),
                                          onPressed: () => controller.favWatch(
                                              path: FirebaseUserPaths.watchlist,
                                              id: controller.detales.id
                                                  .toString(),
                                              context: context)),
                                  CustomText(
                                    text: controller.detales.voteAverage!
                                        .toString(),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: width * 0.06,
                                  )
                                ],
                              ),
                            ),
                          ),
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SquareButton(
                                      clear: true,
                                      function: () => Get.back(),
                                      height: width * 0.11,
                                      width: width * 0.11,
                                      padding: 0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      icon: isIos
                                          ? CupertinoIcons.back
                                          : Icons.arrow_back,
                                      iconColor:
                                          Theme.of(context).colorScheme.primary,
                                      isFilled: false),
                                  GestureDetector(
                                    onTap: () => controller.favWatch(
                                      context: context,
                                      path: FirebaseUserPaths.favorites,
                                      id: controller.detales.id.toString(),
                                    ),
                                    child: Icon(
                                        controller.userModel.favs!.contains(
                                          controller.detales.id.toString(),
                                        )
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: width * 0.09),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomText(
                          text: controller.detales.title.toString(),
                          size: width * 0.05,
                          maxline: 2,
                          flow: TextOverflow.ellipsis,
                          weight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        height: height * 0.05,
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.detales.genres != null
                              ? controller.detales.genres!.length
                              : 3,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return CustomText(
                                text: controller.detales.genres == null
                                    ? 'genre'.tr
                                    : controller.detales.genres![index],
                                color: Theme.of(context).colorScheme.primary,
                                size: width * 0.045);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return CustomText(
                                text: ' | ',
                                color: Theme.of(context).colorScheme.primary,
                                size: width * 0.04);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: (width - 32) * 0.2,
                            child: Column(
                              children: [
                                CustomText(
                                  text: 'Year'.tr,
                                  size: width * 0.035,
                                  flow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                CustomText(
                                  text:
                                      controller.detales.releaseDate.toString(),
                                  color: Theme.of(context).colorScheme.primary,
                                  size: width * 0.04,
                                  weight: FontWeight.bold,
                                  flow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (width - 32) * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'country'.tr,
                                  size: width * 0.035,
                                  flow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                CustomText(
                                  align: TextAlign.center,
                                  text: controller.detales.originCountry
                                              .toString() ==
                                          ''
                                      ? 'country'.tr
                                      : controller.detales.originCountry
                                          .toString(),
                                  color: Theme.of(context).colorScheme.primary,
                                  size: width * 0.04,
                                  weight: FontWeight.bold,
                                  flow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (width - 32) * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  isFit: true,
                                  text: controller.detales.isError == false
                                      ? controller.detales.isShow == false
                                          ? 'length'.tr
                                          : 'seasons'.tr
                                      : controller.detales.isShow == false
                                          ? 'length'.tr
                                          : 'seasons'.tr,
                                  size: width * 0.035,
                                  flow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 3),
                                CustomText(
                                  text: controller.detales.isShow == false
                                      ? getTimeString(
                                          controller.detales.runtime as int)
                                      : controller.detales.runtime.toString(),
                                  color: Theme.of(context).colorScheme.primary,
                                  size: width * 0.04,
                                  weight: FontWeight.bold,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      indent: width * 0.05,
                      endIndent: width * 0.05,
                      thickness: 1.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: (controller.detales.isShow == true
                                ? width / 3
                                : width / 2),
                            height: width * 0.12,
                            child: TabWidget(
                              padding: const EdgeInsets.all(0),
                              width: width * 0.5,
                              function: () => controller.tabChange(tab: 1),
                              title: 'overview'.tr,
                              selected: controller.tabs == 1,
                              platform: authController.platform,
                              height: width * 0.12,
                            ),
                          ),
                          if (controller.detales.isShow == true) ...[
                            SizedBox(
                              width: (controller.detales.isShow == true
                                  ? width / 3
                                  : width / 2),
                              height: width * 0.12,
                              child: TabWidget(
                                padding: const EdgeInsets.all(0),
                                width: width * 0.5,
                                function: () => controller.tabChange(tab: 3),
                                title: 'episodes'.tr,
                                selected: controller.tabs == 3,
                                platform: authController.platform,
                                height: width * 0.12,
                              ),
                            ),
                          ],
                          SizedBox(
                            width: (controller.detales.isShow == true
                                ? width / 3
                                : width / 2),
                            height: width * 0.12,
                            child: TabWidget(
                              padding: const EdgeInsets.all(0),
                              width: width * 0.5,
                              function: () => controller.tabChange(tab: 2),
                              title: 'comments'.tr,
                              selected: controller.tabs == 2,
                              platform: authController.platform,
                              height: width * 0.12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (controller.tabs == 1) ...[
                      ContentScrolling(
                        padding: 12,
                        other: maxLines(
                            text: controller.detales.overview.toString(),
                            width: width - 16,
                            maxLines: 4),
                        otherMore: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            onTap: () => controller.storyFlip(
                                over: maxLines(
                                    text:
                                        controller.detales.overview.toString(),
                                    width: width - 16,
                                    maxLines: 4)),
                            child: AnimatedIcon(
                              icon: AnimatedIcons.menu_close,
                              progress: controller.controller,
                            ),
                          ),
                        ),
                        isIos: isIos,
                        title: 'story'.tr,
                        titleSize: 18,
                        more: false,
                        mainWidget: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: GestureDetector(
                            onTap: () => controller.storyFlip(
                                over: maxLines(
                                    text:
                                        controller.detales.overview.toString(),
                                    width: width - 16,
                                    maxLines: 4)),
                            child: CustomText(
                              text: controller.detales.overview.toString(),
                              flow: maxLines(
                                      text: controller.detales.overview
                                          .toString(),
                                      width: width - 16,
                                      maxLines: 4)
                                  ? controller.storyOpen
                                      ? null
                                      : TextOverflow.ellipsis
                                  : null,
                              maxline: maxLines(
                                      text: controller.detales.overview
                                          .toString(),
                                      width: width - 16,
                                      maxLines: 4)
                                  ? controller.storyOpen
                                      ? null
                                      : 4
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: ContentScrolling(
                          load:
                              controller.detales.isError == false ? null : true,
                          reload: () =>
                              controller.getData(res: controller.detales),
                          isIos: isIos,
                          title: 'cast'.tr,
                          titleSize: 18,
                          more: controller.loading == 1 ||
                                  controller.detales.isError == false
                              ? false
                              : true,
                          mainWidget: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(
                                controller.loading == 1
                                    ? 10
                                    : controller.detales.isError == false &&
                                            controller.detales.cast!.isError ==
                                                false
                                        ? controller.detales.cast!.cast!.length
                                        : 10,
                                (index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: controller.loading == 1 ||
                                          controller.detales.isError == true ||
                                          controller.detales.cast!.isError ==
                                              true
                                      ? MovieWidget(
                                          circle: true,
                                          borderColor: Colors.transparent,
                                          height: width * 0.2,
                                          width: width * 0.2,
                                          link: '',
                                          provider: Image.asset('name').image,
                                          shimmer: true,
                                          shadow: false)
                                      : Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () => Get.find<
                                                      HomeController>()
                                                  .navToDetale(
                                                      res: ResultsDetail(
                                                          voteAverage: 0,
                                                          id: controller
                                                              .detales
                                                              .cast!
                                                              .cast![index]
                                                              .id,
                                                          posterPath: controller
                                                              .detales
                                                              .cast!
                                                              .cast![index]
                                                              .profilePath,
                                                          title: controller
                                                              .detales
                                                              .cast!
                                                              .cast![index]
                                                              .name,
                                                          mediaType: 'person')),
                                              child: Hero(
                                                tag: controller.detales.cast!
                                                    .cast![index].id
                                                    .toString(),
                                                child: ImageNetWork(
                                                  border: Colors.transparent,
                                                  circle: true,
                                                  link: imagebase +
                                                      controller
                                                          .detales
                                                          .cast!
                                                          .cast![index]
                                                          .profilePath
                                                          .toString(),
                                                  height: width * 0.2,
                                                  width: width * 0.2,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: SizedBox(
                                                width: width * 0.2,
                                                child: Column(
                                                  children: [
                                                    CustomText(
                                                      maxline: 1,
                                                      align: TextAlign.center,
                                                      flow:
                                                          TextOverflow.ellipsis,
                                                      size: width * 0.029,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      text: controller
                                                          .detales
                                                          .cast!
                                                          .cast![index]
                                                          .name
                                                          .toString(),
                                                    ),
                                                    CustomText(
                                                      flow:
                                                          TextOverflow.ellipsis,
                                                      align: TextAlign.center,
                                                      size: width * 0.025,
                                                      isFit: false,
                                                      maxline: 1,
                                                      text: controller
                                                                  .detales
                                                                  .cast!
                                                                  .cast![index]
                                                                  .character
                                                                  .toString() ==
                                                              ''
                                                          ? 'unknown'.tr
                                                          : 'As ${controller.detales.cast!.cast![index].character.toString()}',
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (controller.detales.isError == false &&
                          controller.detales.collectionId.toString() != '' &&
                          controller.detales.collection!.isError == false) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: ContentScrolling(
                            more: controller.loading == 1 ||
                                    controller.detales.isError == false
                                ? false
                                : true,
                            load: controller.detales.isError == false
                                ? null
                                : true,
                            reload: () =>
                                controller.getData(res: controller.detales),
                            isIos: isIos,
                            title: 'parts'.tr,
                            titleSize: 18,
                            mainWidget: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  controller.loading == 1
                                      ? 10
                                      : controller.detales.isError == false &&
                                              controller.detales.collection!
                                                      .isError ==
                                                  false
                                          ? controller.detales.collection!
                                              .results!.length
                                          : 10,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: controller.loading == 1 ||
                                            controller.detales.isError ==
                                                true ||
                                            controller.detales.collection!
                                                    .isError ==
                                                true
                                        ? MovieWidget(
                                            height: (width * 0.4) * 1.3,
                                            width: width * 0.35,
                                            link: '',
                                            provider: Image.asset('name').image,
                                            shimmer: true,
                                            shadow: false)
                                        : ImageNetWork(
                                            function: () =>
                                                Get.find<HomeController>()
                                                    .navToDetale(
                                                        res: controller
                                                            .detales
                                                            .collection!
                                                            .results![index]),
                                            link: imagebase +
                                                controller.detales.collection!
                                                    .results![index].posterPath
                                                    .toString(),
                                            height: (width * 0.4) * 1.3,
                                            width: width * 0.35,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                      if (controller.detales.isError == false &&
                          controller.detales.recomendation!.isError == false &&
                          controller
                              .detales.recomendation!.results!.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: ContentScrolling(
                            more: controller.loading == 1 ||
                                    controller.detales.isError == false
                                ? false
                                : true,
                            load: controller.detales.isError == false
                                ? null
                                : true,
                            reload: () =>
                                controller.getData(res: controller.detales),
                            isIos: isIos,
                            title: 'recommendations'.tr,
                            titleSize: 18,
                            mainWidget: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  controller.loading == 1
                                      ? 10
                                      : controller.detales.isError == false &&
                                              controller.detales.recomendation!
                                                      .isError ==
                                                  false
                                          ? controller.detales.recomendation!
                                              .results!.length
                                          : 10,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: controller.loading == 1 ||
                                            controller.detales.isError ==
                                                true ||
                                            controller.detales.recomendation!
                                                    .isError ==
                                                true
                                        ? MovieWidget(
                                            height: (width * 0.4) * 1.3,
                                            width: width * 0.35,
                                            link: '',
                                            provider: Image.asset('name').image,
                                            shimmer: true,
                                            shadow: false)
                                        : ImageNetWork(
                                            function: () =>
                                                Get.find<HomeController>()
                                                    .navToDetale(
                                                        res: controller
                                                            .detales
                                                            .recomendation!
                                                            .results![index]),
                                            link: imagebase +
                                                controller
                                                    .detales
                                                    .recomendation!
                                                    .results![index]
                                                    .posterPath
                                                    .toString(),
                                            height: (width * 0.4) * 1.3,
                                            width: width * 0.35,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]
                    ],
                    if (controller.tabs == 3) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Menu(
                              ios: isIos,
                              titles: List.generate(
                                  controller.detales.runtime as int,
                                  (index) => '${'sason'.tr} ${index + 1}'),
                              funcs: List.generate(
                                controller.detales.runtime as int,
                                (index) => () {
                                  controller.seasonChange(
                                      index: index + 1, season: index + 1);
                                },
                              ),
                              child: Container(
                                width: width * 0.25,
                                height: width * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.5),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CustomText(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      text:
                                          '${'sason'.tr} ${controller.seasonTrack}',
                                      size: width * 0.04,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Menu(
                              ios: isIos,
                              titles: ['ascend'.tr, 'decend'.tr],
                              funcs: [
                                () {
                                  if (isIos) {
                                    Get.back();
                                  }
                                  controller.episodeSort(ascending: true);
                                },
                                () {
                                  if (isIos) {
                                    Get.back();
                                  }
                                  controller.episodeSort(ascending: false);
                                },
                              ],
                              child: Icon(
                                controller.isAscending
                                    ? FontAwesomeIcons.arrowDownShortWide
                                    : FontAwesomeIcons.arrowDownWideShort,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                      controller.loading == 1 || controller.loadingSeason == 1
                          ? SizedBox(
                              width: width,
                              height: width * 0.5,
                              child: Center(
                                child: isIos
                                    ? CupertinoActivityIndicator(
                                        radius: width * 0.04,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      )
                                    : CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            )
                          : controller.detales.isError == true ||
                                  controller.detales.seaosn!.isError == true
                              ? SizedBox(
                                  width: width,
                                  height: width * 0.5,
                                  child: Center(
                                    child: isIos
                                        ? CupertinoButton(
                                            child: const Icon(
                                              CupertinoIcons.refresh,
                                            ),
                                            onPressed: () {},
                                          )
                                        : IconButton(
                                            icon: const Icon(Icons.refresh),
                                            onPressed: () {},
                                          ),
                                  ),
                                )
                              : Column(
                                  children: List.generate(
                                    controller.detales.seaosn!.episodes!.length,
                                    (index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ExpansionTile(
                                          leading: ImageNetWork(
                                            link: imagebase +
                                                controller
                                                    .detales
                                                    .seaosn!
                                                    .episodes![index]
                                                    .posterPath,
                                            width: width * 0.1,
                                            height: width * 0.1,
                                            border: Colors.transparent,
                                          ),
                                          title: CustomText(
                                            text: controller.detales.seaosn!
                                                .episodes![index].name
                                                .toString(),
                                          ),
                                          subtitle: CustomText(
                                            text:
                                                '${'epnum'.tr} ${controller.detales.seaosn!.episodes![index].episodeNumber} - ${controller.detales.seaosn!.episodes![index].voteAverage.toStringAsFixed(1)} - ${controller.detales.seaosn!.episodes![index].runTime} m - ${controller.detales.seaosn!.episodes![index].airDate}',
                                          ),
                                          trailing: controller.detales.seaosn!
                                                  .episodes![index].loading
                                              ? isIos
                                                  ? CupertinoActivityIndicator(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    )
                                                  : const CircularProgressIndicator()
                                              : Icon(
                                                  isDatePassed(
                                                          time: controller
                                                              .detales
                                                              .seaosn!
                                                              .episodes![index]
                                                              .airDate)
                                                      ? Icons.tv
                                                      : Icons.tv_off,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                onTap: () =>
                                                    controller.episodeTrailer(
                                                  index: index,
                                                  episode: controller
                                                      .detales
                                                      .seaosn!
                                                      .episodes![index]
                                                      .episodeNumber
                                                      .toString(),
                                                  context: context,
                                                  content: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child:
                                                          SingleChildScrollView(
                                                        physics:
                                                            const BouncingScrollPhysics(),
                                                        child: Column(
                                                          children:
                                                              List.generate(
                                                            controller.episodeModel
                                                                        .isError ==
                                                                    false
                                                                ? controller
                                                                    .episodeModel
                                                                    .results!
                                                                    .length
                                                                : 0,
                                                            (index) {
                                                              return Material(
                                                                child: ListTile(
                                                                  onTap: () => controller.launcherUse(
                                                                      url:
                                                                          'https://www.youtube.com/watch?v=${controller.episodeModel.results![index].key}',
                                                                      context:
                                                                          context),
                                                                  title: CustomText(
                                                                      maxline:
                                                                          2,
                                                                      flow: TextOverflow
                                                                          .ellipsis,
                                                                      text: controller
                                                                          .episodeModel
                                                                          .results![
                                                                              index]
                                                                          .name
                                                                          .toString()),
                                                                  subtitle: CustomText(
                                                                      text: controller
                                                                          .episodeModel
                                                                          .results![
                                                                              index]
                                                                          .type
                                                                          .toString()),
                                                                  leading: ImageNetWork(
                                                                      border: Colors
                                                                          .transparent,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      link:
                                                                          'https://img.youtube.com/vi/${controller.episodeModel.results![index].key.toString()}/0.jpg',
                                                                      width:
                                                                          width *
                                                                              0.2,
                                                                      height:
                                                                          width *
                                                                              0.2),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                child: CustomText(
                                                    text: controller
                                                        .detales
                                                        .seaosn!
                                                        .episodes![index]
                                                        .overview),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                    ],
                    if (controller.tabs == 2) ...[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                controller.commentOpen == false
                                    ? isIos
                                        ? CupertinoButton(
                                            child: FaIcon(FontAwesomeIcons.plus,
                                                size: width * 0.05,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary),
                                            onPressed: () =>
                                                controller.commentFlip(),
                                          )
                                        : IconButton(
                                            onPressed: () =>
                                                controller.commentFlip(),
                                            icon: FaIcon(
                                              size: width * 0.05,
                                              FontAwesomeIcons.plus,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            splashRadius: 15,
                                          )
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: LoginInput(
                                            suffex: isIos
                                                ? CupertinoButton(
                                                    child: FaIcon(
                                                      FontAwesomeIcons
                                                          .paperPlane,
                                                      color: controller
                                                              .commentSelected
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .primary
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                    ),
                                                    onPressed: () => controller
                                                        .commentUpload(
                                                            reply: false),
                                                  )
                                                : IconButton(
                                                    onPressed: () => controller
                                                        .commentUpload(
                                                            reply: false),
                                                    icon: FaIcon(
                                                      FontAwesomeIcons
                                                          .paperPlane,
                                                      color: controller
                                                              .commentSelected
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .primary
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .secondary,
                                                    ),
                                                    splashRadius: 15,
                                                  ),
                                            leadingButton: CupertinoButton(
                                              child: FaIcon(
                                                FontAwesomeIcons.xmark,
                                                color:
                                                    controller.commentSelected
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                              ),
                                              onPressed: () =>
                                                  controller.commentFlip(),
                                            ),
                                            hintNoLable: 'commentsad'.tr,
                                            maxLine: 5,
                                            controller:
                                                controller.commentController,
                                            focusNode: controller.focusNode,
                                            isSearch: true,
                                            height: width * 0.2,
                                            width: width * 0.85,
                                            obscure: false,
                                            otherShadow: false,
                                            isSelected:
                                                controller.commentSelected),
                                      ),
                                SizedBox(
                                  height: width * 0.12,
                                  width: (width * 0.15) - 16,
                                  child: Center(
                                    child: Menu(
                                      ios: isIos,
                                      titles: [
                                        'timerecent'.tr,
                                        'timeold'.tr,
                                        'mostlikes'.tr,
                                        'leastlikes'.tr,
                                        'mostrep'.tr
                                      ],
                                      funcs: [
                                        () => controller.commentOrder(
                                            isIos: isIos,
                                            order: CommentOrder.timeRecent),
                                        () => controller.commentOrder(
                                            isIos: isIos,
                                            order: CommentOrder.timeOld),
                                        () => controller.commentOrder(
                                            isIos: isIos,
                                            order: CommentOrder.mostLikes),
                                        () => controller.commentOrder(
                                            isIos: isIos,
                                            order: CommentOrder.leastLikes),
                                        () => controller.commentOrder(
                                            isIos: isIos,
                                            order: CommentOrder.replies)
                                      ],
                                      child: FaIcon(
                                        size: width * 0.05,
                                        FontAwesomeIcons.arrowDownWideShort,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            controller.commentLoading == 0
                                ? Column(
                                    children: List.generate(
                                      controller.commentList.length,
                                      (index) {
                                        return CommentWidget(
                                          sendRep: () =>
                                              controller.reply(index: index),
                                          paper: controller.replyToComment
                                                      .trim() ==
                                                  ''
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          repChange: (rep) => controller
                                              .replyChange(reply: rep),
                                          repBox: controller.commentList[index]
                                              .replyBox as bool,
                                          flipRep: () =>
                                              controller.repFlip(index: index),
                                          showRep: controller.commentList[index]
                                              .showRep as bool,
                                          likes: controller
                                              .commentList[index].likes,
                                          dislikes: controller
                                              .commentList[index].dislikea,
                                          profileNav: () =>
                                              controller.navToProfile(
                                                  index: index,
                                                  reply: false,
                                                  repIndex: 0),
                                          hasMore: controller
                                              .commentList[index].hasMore,
                                          like: () => controller.likeController(
                                              reply: false,
                                              repIndex: 0,
                                              like: true,
                                              index: index),
                                          dislike: () =>
                                              controller.likeController(
                                                  reply: false,
                                                  repIndex: 0,
                                                  like: false,
                                                  index: index),
                                          commentToggle: () =>
                                              controller.commentFull(
                                                  index: index,
                                                  reply: false,
                                                  repIndex: 0),
                                          delete: () =>
                                              controller.commentDelete(
                                                  reply: false,
                                                  repIndex: 0,
                                                  index: index,
                                                  context: context,
                                                  isIos: isIos),
                                          replies: () => controller.repBoxOpen(
                                            index: index,
                                          ),
                                          isLiked: controller
                                              .userModel.commentLike!
                                              .contains(controller
                                                  .commentList[index]
                                                  .commentId),
                                          isDisLiked: controller
                                              .userModel.commentDislike!
                                              .contains(controller
                                                  .commentList[index]
                                                  .commentId),
                                          commentOpen: controller
                                              .commentList[index].commentOpen,
                                          isIos: isIos,
                                          elevation: 5,
                                          imageBorder: false,
                                          imageLink: controller
                                              .commentList[index].userLink,
                                          width: width,
                                          isMe: controller
                                                  .commentList[index].userId ==
                                              controller.userModel.userId
                                                  .toString(),
                                          timeAgo: timeAgo(controller
                                              .commentList[index].time),
                                          comment: controller
                                              .commentList[index].comment,
                                          userName: controller
                                              .commentList[index].userName,
                                          replyNum: controller
                                              .commentList[index].repliesNum,
                                          subs: controller.commentList[index]
                                                          .subComments ==
                                                      null ||
                                                  controller.commentList[index]
                                                          .showRep ==
                                                      false
                                              ? null
                                              : Column(
                                                  children: List.generate(
                                                    controller
                                                        .commentList[index]
                                                        .subComments!
                                                        .length,
                                                    (comIndex) {
                                                      return CommentWidget(
                                                        repBox: controller
                                                            .commentList[index]
                                                            .replyBox as bool,
                                                        flipRep: () =>
                                                            controller.repFlip(
                                                                index: index),
                                                        showRep: controller
                                                            .commentList[index]
                                                            .showRep as bool,
                                                        subComments: true,
                                                        likes: controller
                                                            .commentList[index]
                                                            .subComments![
                                                                comIndex]
                                                            .likes,
                                                        dislikes: controller
                                                            .commentList[index]
                                                            .subComments![
                                                                comIndex]
                                                            .dislikea,
                                                        profileNav: () =>
                                                            controller
                                                                .navToProfile(
                                                                    reply: true,
                                                                    repIndex:
                                                                        comIndex,
                                                                    index:
                                                                        index),
                                                        hasMore: false,
                                                        like: () => controller
                                                            .likeController(
                                                                reply: true,
                                                                repIndex:
                                                                    comIndex,
                                                                like: true,
                                                                index: index),
                                                        dislike: () => controller
                                                            .likeController(
                                                                reply: true,
                                                                repIndex:
                                                                    comIndex,
                                                                like: false,
                                                                index: index),
                                                        commentToggle: () =>
                                                            controller
                                                                .commentFull(
                                                                    repIndex:
                                                                        comIndex,
                                                                    reply: true,
                                                                    index:
                                                                        index),
                                                        delete: () => controller
                                                            .commentDelete(
                                                                reply: true,
                                                                repIndex:
                                                                    comIndex,
                                                                index: index,
                                                                context:
                                                                    context,
                                                                isIos: isIos),
                                                        replies: () {},
                                                        isLiked: controller
                                                            .userModel
                                                            .commentLike!
                                                            .contains(controller
                                                                .commentList[
                                                                    index]
                                                                .subComments![
                                                                    comIndex]
                                                                .commentId),
                                                        isDisLiked: controller
                                                            .userModel
                                                            .commentDislike!
                                                            .contains(controller
                                                                .commentList[
                                                                    index]
                                                                .subComments![
                                                                    comIndex]
                                                                .commentId),
                                                        commentOpen: controller
                                                            .commentList[index]
                                                            .subComments![
                                                                comIndex]
                                                            .commentOpen,
                                                        isIos: isIos,
                                                        elevation: 5,
                                                        imageBorder: false,
                                                        imageLink: controller
                                                            .commentList[index]
                                                            .subComments![
                                                                comIndex]
                                                            .userLink,
                                                        width: width,
                                                        isMe: controller
                                                                .commentList[
                                                                    index]
                                                                .subComments![
                                                                    comIndex]
                                                                .userId ==
                                                            controller.userModel
                                                                .userId
                                                                .toString(),
                                                        timeAgo: timeAgo(
                                                            controller
                                                                .commentList[
                                                                    index]
                                                                .subComments![
                                                                    comIndex]
                                                                .time),
                                                        comment: controller
                                                            .commentList[index]
                                                            .subComments![
                                                                comIndex]
                                                            .comment,
                                                        userName: controller
                                                            .commentList[index]
                                                            .subComments![
                                                                comIndex]
                                                            .userName,
                                                        replyNum: controller
                                                            .commentList[index]
                                                            .subComments![
                                                                comIndex]
                                                            .repliesNum,
                                                      );
                                                    },
                                                  ),
                                                ),
                                        );
                                      },
                                    ),
                                  )
                                : SizedBox(
                                    height: height * 0.2,
                                    width: width,
                                    child: Center(
                                      child: isIos
                                          ? CupertinoActivityIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            )
                                          : CircularProgressIndicator(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                    ),
                                  )
                          ],
                        ),
                      )
                    ]
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
