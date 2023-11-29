import 'package:carousel_slider/carousel_slider.dart';
import 'package:cineverse/controllers/actor_controller.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:cineverse/widgets/avatar_widget.dart';
import 'package:cineverse/widgets/content_scrolling.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:cineverse/widgets/movie_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ActorPhone extends StatelessWidget {
  const ActorPhone({super.key});

  @override
  Widget build(BuildContext context) {
    bool isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: CustomText(
          text: 'biog'.tr,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: GetBuilder<ActorController>(
        init: Get.find<ActorController>(),
        builder: (controller) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LoginInput(
                    otherShadow: true,
                    height: height * 0.175,
                    width: width,
                    obscure: false,
                    isSelected: true,
                    other: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Hero(
                            tag: controller.tag,
                            child: GestureDetector(
                              onTap: () => controller.getImages(
                                isIos: isIos,
                                height: height,
                                width: width,
                                isActor: true,
                                id: controller.actor.id.toString(),
                                content: GetBuilder<ActorController>(
                                  init: Get.find<ActorController>(),
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
                                        : controller.imageModel.isError == false
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
                                                    border: Colors.transparent,
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
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                        child:
                                                            Text("answer".tr),
                                                        onPressed: () async => {
                                                          Get.back(),
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                  ),
                                ),
                              ),
                              child: Avatar(
                                width: width * 0.25,
                                height: width * 0.25,
                                isBorder: true,
                                type: AvatarType.online,
                                boxFit: BoxFit.cover,
                                shadow: true,
                                link: imagebase +
                                    controller.actor.link.toString(),
                                borderColor:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: CustomText(
                                    size: 20,
                                    maxline: 2,
                                    flow: TextOverflow.ellipsis,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    text: controller.actor.name.toString(),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: CustomText(
                                    size: 16,
                                    maxline: 1,
                                    flow: TextOverflow.ellipsis,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    text:
                                        '${'age'.tr} : ${controller.actor.birth == null || controller.actor.birth.toString() == '' ? 0 : calculateAge(birthDate: controller.actor.birth.toString())}',
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      right: 12, left: 12, top: 12, bottom: 32),
                  child: LoginInput(
                    height: height * 0.7,
                    width: width,
                    obscure: false,
                    isSelected: true,
                    other: SingleChildScrollView(
                      child: SizedBox(
                        height: height * 0.7,
                        width: width,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ContentScrolling(
                                padding: 12,
                                other: maxLines(
                                    text: controller.actor.bio.toString(),
                                    width: width - 16,
                                    maxLines: 4),
                                otherMore: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () => controller.storyFlip(
                                        over: maxLines(
                                            text:
                                                controller.actor.bio.toString(),
                                            width: width - 16,
                                            maxLines: 4)),
                                    child: AnimatedIcon(
                                      icon: AnimatedIcons.menu_close,
                                      progress: controller.controller,
                                    ),
                                  ),
                                ),
                                isIos: isIos,
                                title: 'biog'.tr,
                                titleSize: 18,
                                more: false,
                                mainWidget: controller.loading
                                    ? Center(
                                        child: isIos
                                            ? const CupertinoActivityIndicator()
                                            : const CircularProgressIndicator(),
                                      )
                                    : controller.actor.bio == '' ||
                                            controller.actor.isError == true
                                        ? Center(
                                            child: CustomText(
                                              text: 'nobio'.tr,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: GestureDetector(
                                              onTap: () => controller.storyFlip(
                                                  over: maxLines(
                                                      text: controller.actor.bio
                                                          .toString(),
                                                      width: width - 16,
                                                      maxLines: 4)),
                                              child: CustomText(
                                                text: controller.actor.bio
                                                    .toString(),
                                                flow: maxLines(
                                                        text: controller
                                                            .actor.bio
                                                            .toString(),
                                                        width: width - 16,
                                                        maxLines: 4)
                                                    ? controller.storyOpen
                                                        ? null
                                                        : TextOverflow.ellipsis
                                                    : null,
                                                maxline: maxLines(
                                                        text: controller
                                                            .actor.bio
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
                              if (controller
                                  .actor.detales!.actedMovies!.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: ContentScrolling(
                                    more: false,
                                    isIos: isIos,
                                    title: 'actedmovie'.tr,
                                    titleSize: 18,
                                    mainWidget: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          controller.loading == true
                                              ? 10
                                              : controller.actor.isError ==
                                                          false &&
                                                      controller.actor.detales!
                                                              .isError ==
                                                          false
                                                  ? controller.actor.detales!
                                                      .actedMovies!.length
                                                  : 10,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: controller.loading == true ||
                                                    controller.actor.isError ==
                                                        true ||
                                                    controller.actor.detales!
                                                            .isError ==
                                                        true
                                                ? MovieWidget(
                                                    height: (width * 0.4) * 1.1,
                                                    width: width * 0.3,
                                                    link: '',
                                                    provider:
                                                        Image.asset('name')
                                                            .image,
                                                    shimmer: true,
                                                    shadow: false)
                                                : ImageNetWork(
                                                    function: () => Get.find<
                                                            HomeController>()
                                                        .navToDetale(
                                                            res: controller
                                                                    .actor
                                                                    .detales!
                                                                    .actedMovies![
                                                                index]),
                                                    link: imagebase +
                                                        controller
                                                            .actor
                                                            .detales!
                                                            .actedMovies![index]
                                                            .posterPath
                                                            .toString(),
                                                    height: (width * 0.4) * 1.1,
                                                    width: width * 0.3,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                              if (controller
                                  .actor.detales!.actedShows!.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: ContentScrolling(
                                    more: false,
                                    isIos: isIos,
                                    title: 'actedinshows'.tr,
                                    titleSize: 18,
                                    mainWidget: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          controller.loading == true
                                              ? 10
                                              : controller.actor.isError ==
                                                          false &&
                                                      controller.actor.detales!
                                                              .isError ==
                                                          false
                                                  ? controller.actor.detales!
                                                      .actedShows!.length
                                                  : 10,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: controller.loading == true ||
                                                    controller.actor.isError ==
                                                        true ||
                                                    controller.actor.detales!
                                                            .isError ==
                                                        true
                                                ? MovieWidget(
                                                    height: (width * 0.4) * 1.1,
                                                    width: width * 0.3,
                                                    link: '',
                                                    provider:
                                                        Image.asset('name')
                                                            .image,
                                                    shimmer: true,
                                                    shadow: false)
                                                : ImageNetWork(
                                                    function: () => Get.find<
                                                            HomeController>()
                                                        .navToDetale(
                                                            res: controller
                                                                    .actor
                                                                    .detales!
                                                                    .actedShows![
                                                                index]),
                                                    link: imagebase +
                                                        controller
                                                            .actor
                                                            .detales!
                                                            .actedShows![index]
                                                            .posterPath
                                                            .toString(),
                                                    height: (width * 0.4) * 1.1,
                                                    width: width * 0.3,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                              if (controller
                                  .actor.detales!.directed!.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: ContentScrolling(
                                    more: false,
                                    isIos: isIos,
                                    title: 'directed'.tr,
                                    titleSize: 18,
                                    mainWidget: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          controller.loading == true
                                              ? 10
                                              : controller.actor.isError ==
                                                          false &&
                                                      controller.actor.detales!
                                                              .isError ==
                                                          false
                                                  ? controller.actor.detales!
                                                      .directed!.length
                                                  : 10,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: controller.loading == true ||
                                                    controller.actor.isError ==
                                                        true ||
                                                    controller.actor.detales!
                                                            .isError ==
                                                        true
                                                ? MovieWidget(
                                                    height: (width * 0.4) * 1.1,
                                                    width: width * 0.3,
                                                    link: '',
                                                    provider:
                                                        Image.asset('name')
                                                            .image,
                                                    shimmer: true,
                                                    shadow: false)
                                                : ImageNetWork(
                                                    function: () => Get.find<
                                                            HomeController>()
                                                        .navToDetale(
                                                            res: controller
                                                                    .actor
                                                                    .detales!
                                                                    .directed![
                                                                index]),
                                                    link: imagebase +
                                                        controller
                                                            .actor
                                                            .detales!
                                                            .directed![index]
                                                            .posterPath
                                                            .toString(),
                                                    height: (width * 0.4) * 1.1,
                                                    width: width * 0.3,
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                              if (controller
                                  .actor.detales!.produced!.isNotEmpty) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0),
                                  child: ContentScrolling(
                                    more: false,
                                    isIos: isIos,
                                    title: 'produced'.tr,
                                    titleSize: 18,
                                    mainWidget: SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List.generate(
                                          controller.loading == true
                                              ? 10
                                              : controller.actor.isError ==
                                                          false &&
                                                      controller.actor.detales!
                                                              .isError ==
                                                          false
                                                  ? controller.actor.detales!
                                                      .produced!.length
                                                  : 10,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: controller.loading == true ||
                                                    controller.actor.isError ==
                                                        true ||
                                                    controller.actor.detales!
                                                            .isError ==
                                                        true
                                                ? MovieWidget(
                                                    height: (width * 0.4) * 1.1,
                                                    width: width * 0.3,
                                                    link: '',
                                                    provider:
                                                        Image.asset('name')
                                                            .image,
                                                    shimmer: true,
                                                    shadow: false)
                                                : ImageNetWork(
                                                    function: () => Get.find<
                                                            HomeController>()
                                                        .navToDetale(
                                                            res: controller
                                                                    .actor
                                                                    .detales!
                                                                    .produced![
                                                                index]),
                                                    link: imagebase +
                                                        controller
                                                            .actor
                                                            .detales!
                                                            .produced![index]
                                                            .posterPath
                                                            .toString(),
                                                    height: (width * 0.4) * 1.1,
                                                    width: width * 0.3,
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
                        ),
                      ),
                    ),
                    otherShadow: true,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
