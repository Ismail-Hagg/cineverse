import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/result_details_model.dart';
import 'package:cineverse/pages/settings_page/settings_view_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/widgets/avatar_widget.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:cineverse/widgets/tab_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';

class ProfilePhone extends StatelessWidget {
  const ProfilePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfilePageController>(
      init: Get.find<ProfilePageController>(),
      builder: (controller) {
        bool isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
        bool isMe = controller.model.userId.toString() ==
            Get.find<AuthController>().userModel.userId.toString();
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: CustomText(
              text: 'profile'.tr,
              color: Theme.of(context).colorScheme.primary,
            ),
            centerTitle: true,
            leading: isMe
                ? null
                : isIos
                    ? CupertinoButton(
                        child: Icon(CupertinoIcons.back,
                            color: Theme.of(context).colorScheme.primary),
                        onPressed: () => controller.goBack(),
                      )
                    : IconButton(
                        splashRadius: 15,
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => controller.goBack(),
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            actions: [
              isIos
                  ? CupertinoButton(
                      child: Icon(
                          isMe
                              ? CupertinoIcons.settings
                              : CupertinoIcons.chat_bubble_text_fill,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: () =>
                          Get.to(() => const SettingsViewController()),
                    )
                  : IconButton(
                      splashRadius: 15,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () =>
                          Get.to(() => const SettingsViewController()),
                      icon: Icon(isMe ? Icons.settings : Icons.message),
                    )
            ],
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double width = constraints.maxWidth;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Hero(
                      tag: controller.model.userId.toString(),
                      child: Avatar(
                        width: width * 0.3,
                        height: width * 0.3,
                        isBorder: true,
                        type: AvatarType.online,
                        boxFit: BoxFit.cover,
                        shadow: true,
                        link: controller.model.onlinePicPath.toString(),
                        borderColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Hero(
                    tag: controller.model.userName.toString(),
                    child: CustomText(
                      text: controller.model.userName.toString(),
                      size: width * 0.05,
                      maxline: 2,
                      flow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!isMe) ...[
                    isIos
                        ? CupertinoButton(
                            child: CustomText(
                              text: Get.find<AuthController>()
                                      .userModel
                                      .follwers!
                                      .contains(controller.model.userId)
                                  ? 'unfollow'.tr
                                  : 'follow'.tr,
                              size: 18,
                            ),
                            onPressed: () => controller.follow(),
                          )
                        : TextButton(
                            onPressed: () => controller.follow(),
                            child: CustomText(
                              text: Get.find<AuthController>()
                                      .userModel
                                      .follwers!
                                      .contains(controller.model.userId)
                                  ? 'unfollow'.tr
                                  : 'follow'.tr,
                              size: 18,
                            ),
                          ),
                  ],
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: !isMe ? 24 : 18.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: width / 3,
                          height: width * 0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                color: Theme.of(context).colorScheme.primary,
                                text: 'comments'.tr,
                                size: 16,
                              ),
                              SizedBox(
                                height: (width * 0.12) * 0.15,
                              ),
                              CustomText(
                                text: controller.commentCount.toString(),
                                size: 12,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width / 3,
                          height: width * 0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                color: Theme.of(context).colorScheme.primary,
                                text: 'followers'.tr,
                                size: 16,
                              ),
                              SizedBox(
                                height: (width * 0.12) * 0.15,
                              ),
                              CustomText(
                                text: controller.model.follwers!.length
                                    .toString(),
                                size: 12,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width / 3,
                          height: width * 0.12,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                color: Theme.of(context).colorScheme.primary,
                                text: 'following'.tr,
                                size: 16,
                              ),
                              SizedBox(
                                height: (width * 0.12) * 0.15,
                              ),
                              CustomText(
                                text: controller.model.following!.length
                                    .toString(),
                                size: 12,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GetBuilder<ProfilePageController>(
                      init: Get.find<ProfilePageController>(),
                      builder: (controller) => Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: width / 3,
                                height: width * 0.1,
                                child: TabWidget(
                                  title: 'favourite'.tr,
                                  function: () => controller.changeTabs(tab: 1),
                                  selected: controller.tab == 1,
                                  platform: Get.find<AuthController>().platform,
                                  height: width * 0.1,
                                  width: width * 0.5,
                                  padding: const EdgeInsets.all(0),
                                ),
                              ),
                              SizedBox(
                                width: width / 3,
                                height: width * 0.1,
                                child: TabWidget(
                                  title: 'watchList'.tr,
                                  function: () => controller.changeTabs(tab: 2),
                                  selected: controller.tab == 2,
                                  platform: Get.find<AuthController>().platform,
                                  height: width * 0.1,
                                  width: width * 0.5,
                                  padding: const EdgeInsets.all(0),
                                ),
                              ),
                              SizedBox(
                                width: width / 3,
                                height: width * 0.1,
                                child: TabWidget(
                                  title: 'watching'.tr,
                                  function: () => controller.changeTabs(tab: 3),
                                  selected: controller.tab == 3,
                                  platform: Get.find<AuthController>().platform,
                                  height: width * 0.1,
                                  width: width * 0.5,
                                  padding: const EdgeInsets.all(0),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: controller.loading == false
                                ? SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Wrap(
                                        runAlignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        alignment: WrapAlignment.center,
                                        spacing: 5,
                                        runSpacing: 5,
                                        children: List.generate(
                                          controller
                                              .lst[controller.tab - 1].length,
                                          (index) => GestureDetector(
                                            onTap: () => Get.find<HomeController>().navToDetale(
                                                res: ResultsDetail(
                                                    posterPath: controller
                                                        .lst[controller.tab - 1]
                                                            [index]
                                                        .posterPath,
                                                    id: controller
                                                        .lst[controller.tab - 1]
                                                            [index]
                                                        .id,
                                                    overview: controller
                                                        .lst[controller.tab - 1]
                                                            [index]
                                                        .overview,
                                                    releaseDate: controller
                                                        .lst[controller.tab - 1]
                                                            [index]
                                                        .releaseDate,
                                                    title: controller
                                                        .lst[controller.tab - 1]
                                                            [index]
                                                        .title,
                                                    voteAverage: controller.lst[controller.tab - 1][index].voteAverage,
                                                    isShow: controller.lst[controller.tab - 1][index].isShow)),
                                            child: ImageNetWork(
                                                shadow: false,
                                                link: imagebase +
                                                    controller
                                                        .lst[controller.tab - 1]
                                                            [index]
                                                        .posterPath
                                                        .toString(),
                                                width: width * 0.32,
                                                height: width * 0.47),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: SizedBox(
                                      height: width * 0.1,
                                      width: width * 0.1,
                                      child: FittedBox(
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
