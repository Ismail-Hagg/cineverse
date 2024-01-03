import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/result_details_model.dart';
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
        bool isMe = controller.isMe;
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: CustomText(
              text: 'profile'.tr,
              color: Theme.of(context).colorScheme.primary,
            ),
            centerTitle: true,
            iconTheme:
                IconThemeData(color: Theme.of(context).colorScheme.primary),
            leading: isMe == true
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
                      onPressed: () => controller.settingChat(isMe: isMe),
                    )
                  : IconButton(
                      splashRadius: 15,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () => controller.settingChat(isMe: isMe),
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
                        type: controller.model.avatarType == AvatarType.local &&
                                controller.checkPic == true
                            ? AvatarType.local
                            : AvatarType.online,
                        boxFit: BoxFit.cover,
                        shadow: true,
                        link: controller.model.avatarType == AvatarType.local &&
                                controller.checkPic == true
                            ? controller.model.localPicPath.toString()
                            : controller.model.onlinePicPath.toString(),
                        borderColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  CustomText(
                    text: controller.model.userName.toString(),
                    size: width * 0.05,
                    maxline: 2,
                    flow: TextOverflow.ellipsis,
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
                          height: width * 0.14,
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
                          height: width * 0.14,
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
                                text: controller.model.follwers!.length == 1 &&
                                        controller.model.follwers![0] == ''
                                    ? '0'
                                    : controller.model.follwers!.length
                                        .toString(),
                                size: 12,
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width / 3,
                          height: width * 0.14,
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
                                text: controller.model.following!.length == 1 &&
                                        controller.model.following![0] == ''
                                    ? '0'
                                    : controller.model.following!.length
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
                                                    posterPath: controller.tab == 3
                                                        ? controller
                                                            .lst[controller.tab - 1]
                                                                [index]
                                                            .$2
                                                            .pic
                                                        : controller
                                                            .lst[controller.tab - 1]
                                                                [index]
                                                            .$1
                                                            .posterPath,
                                                    id: controller.tab == 3
                                                        ? controller
                                                            .lst[controller.tab - 1]
                                                                [index]
                                                            .$2
                                                            .id
                                                        : controller
                                                            .lst[controller.tab - 1]
                                                                [index]
                                                            .$1
                                                            .id,
                                                    overview: controller.tab == 3
                                                        ? controller.lst[controller.tab - 1][index].$2.overView
                                                        : controller.lst[controller.tab - 1][index].$1.overview,
                                                    releaseDate: controller.tab == 3 ? controller.lst[controller.tab - 1][index].$2.releaseDate.toString().substring(0, 4) : controller.lst[controller.tab - 1][index].$1.releaseDate,
                                                    title: controller.tab == 3 ? controller.lst[controller.tab - 1][index].$2.name : controller.lst[controller.tab - 1][index].$1.title,
                                                    voteAverage: controller.tab == 3 ? controller.lst[controller.tab - 1][index].$2.voteAverage : controller.lst[controller.tab - 1][index].$1.voteAverage,
                                                    isShow: controller.tab == 3 ? true : controller.lst[controller.tab - 1][index].$1.isShow)),
                                            child: ImageNetWork(
                                                shadow: false,
                                                link: controller.tab == 3
                                                    ? imagebase +
                                                        controller
                                                            .lst[
                                                                controller.tab -
                                                                    1][index]
                                                            .$2
                                                            .pic
                                                            .toString()
                                                    : imagebase +
                                                        controller
                                                            .lst[
                                                                controller.tab -
                                                                    1][index]
                                                            .$1
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
