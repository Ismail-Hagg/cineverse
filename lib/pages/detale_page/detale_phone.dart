import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:cineverse/widgets/content_scrolling.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:cineverse/widgets/menu_widget.dart';
import 'package:cineverse/widgets/movie_widget.dart';
import 'package:cineverse/widgets/square_button.dart';
import 'package:cineverse/widgets/ios_tab_widget.dart';
import 'package:cineverse/widgets/tab_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: GetBuilder<MovieDetaleController>(
        init: Get.find<MovieDetaleController>(),
        builder: (controller) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            var height = constraints.maxHeight;
            var width = constraints.maxWidth;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.42,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: width,
                          height: height * 0.38,
                          child: ShapeOfView(
                            elevation: 10,
                            shape: ArcShape(
                                direction: ArcDirection.Outside,
                                height: 50,
                                position: ArcPosition.Bottom),
                            child: ImageNetWork(
                                border: Colors.transparent,
                                link: imagebase +
                                    controller.detales.posterPath.toString(),
                                width: width,
                                height: height),
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
                              // controll.goToTrailer(context: context);
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                controller.detales.isShow == true
                                    ? Menu(
                                        ios: false,
                                        titles: ["addtowatch".tr, "addkeep".tr],
                                        funcs: [
                                          () => {
                                                //controller.watch(context: context)
                                              },
                                          () => {
                                                // controller.addKeeping(
                                                //     context: context)
                                              }
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
                                        onPressed: () => {}
                                        //controller.watch(context: context)
                                        ),
                                CustomText(
                                  text: controller.detales.voteAverage!
                                      .toString(),
                                  color: Theme.of(context).colorScheme.primary,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SquareButton(
                                    clear: true,
                                    function: () => Get.back(),
                                    height: width * 0.11,
                                    width: width * 0.11,
                                    padding: 0,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    icon: authController.platform ==
                                            TargetPlatform.iOS
                                        ? CupertinoIcons.back
                                        : Icons.arrow_back,
                                    iconColor:
                                        Theme.of(context).colorScheme.primary,
                                    isFilled: false),
                                // controll.heart == 0
                                //     ? Icon(Icons.favorite_outline,
                                //         color: whiteColor, size: width * 0.08)
                                //     : Icon(Icons.favorite,
                                //         color: orangeColor,
                                //         size: width * 0.08),
                                Icon(Icons.favorite_outline,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: width * 0.09)
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
                        horizontal: 12.0, vertical: 12),
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
                              FittedBox(
                                child: CustomText(
                                  text:
                                      controller.detales.releaseDate.toString(),
                                  color: Theme.of(context).colorScheme.primary,
                                  size: width * 0.04,
                                  weight: FontWeight.bold,
                                  flow: TextOverflow.ellipsis,
                                ),
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
                              FittedBox(
                                child: CustomText(
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
                                ),
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
                              FittedBox(
                                child: CustomText(
                                  text: controller.detales.isShow == false
                                      ? getTimeString(
                                          controller.detales.runtime as int)
                                      : controller.detales.runtime.toString(),
                                  color: Theme.of(context).colorScheme.primary,
                                  size: width * 0.04,
                                  weight: FontWeight.bold,
                                ),
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
                                  text: controller.detales.overview.toString(),
                                  width: width - 16,
                                  maxLines: 4)),
                          child: AnimatedIcon(
                            icon: AnimatedIcons.menu_close,
                            progress: controller.controller,
                          ),
                        ),
                      ),
                      isIos: authController.platform == TargetPlatform.iOS,
                      title: 'story'.tr,
                      titleSize: 18,
                      more: false,
                      mainWidget: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: GestureDetector(
                          onTap: () => controller.storyFlip(
                              over: maxLines(
                                  text: controller.detales.overview.toString(),
                                  width: width - 16,
                                  maxLines: 4)),
                          child: CustomText(
                            text: controller.detales.overview.toString(),
                            flow: maxLines(
                                    text:
                                        controller.detales.overview.toString(),
                                    width: width - 16,
                                    maxLines: 4)
                                ? controller.storyOpen
                                    ? null
                                    : TextOverflow.ellipsis
                                : null,
                            maxline: maxLines(
                                    text:
                                        controller.detales.overview.toString(),
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
                        isIos: authController.platform == TargetPlatform.iOS,
                        title: 'cast'.tr,
                        titleSize: 18,
                        more: false,
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
                                        controller.detales.cast!.isError == true
                                    ? MovieWidget(
                                        circle: true,
                                        borderColor: Colors.transparent,
                                        height: width * 0.2,
                                        width: width * 0.2,
                                        link: '',
                                        provider: Image.asset('name').image,
                                        shimmer: true,
                                        shadow: false)
                                    : ImageNetWork(
                                        border: Colors.transparent,
                                        circle: true,
                                        link: imagebase +
                                            controller.detales.cast!
                                                .cast![index].profilePath
                                                .toString(),
                                        height: width * 0.2,
                                        width: width * 0.2,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: ContentScrolling(
                        isIos: authController.platform == TargetPlatform.iOS,
                        title: 'recommendations'.tr,
                        titleSize: 18,
                        more: false,
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
                                        controller.detales.isError == true ||
                                        controller.detales.cast!.isError == true
                                    ? MovieWidget(
                                        circle: true,
                                        borderColor: Colors.transparent,
                                        height: width * 0.2,
                                        width: width * 0.2,
                                        link: '',
                                        provider: Image.asset('name').image,
                                        shimmer: true,
                                        shadow: false)
                                    : ImageNetWork(
                                        border: Colors.transparent,
                                        circle: true,
                                        link: imagebase +
                                            controller.detales.cast!
                                                .cast![index].profilePath
                                                .toString(),
                                        height: width * 0.2,
                                        width: width * 0.2,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
