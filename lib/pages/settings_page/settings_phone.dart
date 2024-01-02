import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/settings_controller.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/widgets/avatar_widget.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingsPhone extends StatelessWidget {
  const SettingsPhone({super.key});

  @override
  Widget build(BuildContext context) {
    bool isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: CustomText(
          text: 'settings'.tr,
          color: Theme.of(context).colorScheme.primary,
        ),
        centerTitle: true,
      ),
      body: GetBuilder<SettingsController>(
        init: Get.find<SettingsController>(),
        builder: (controller) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LoginInput(
                    otherShadow: true,
                    height: width * 0.3,
                    width: width,
                    obscure: false,
                    isSelected: true,
                    other: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Hero(
                            tag: controller.model.userId.toString(),
                            child: Avatar(
                              width: width * 0.25,
                              height: width * 0.25,
                              isBorder: true,
                              type: AvatarType.online,
                              boxFit: BoxFit.cover,
                              shadow: true,
                              link: controller.model.onlinePicPath.toString(),
                              borderColor:
                                  Theme.of(context).colorScheme.primary,
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
                                    text: controller.model.userName.toString(),
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
                                    text: controller.model.email.toString(),
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: 6.0, left: 6, bottom: width * 0.2, top: 0),
                    child: Card(
                      color: Theme.of(context).colorScheme.background,
                      elevation: 10,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: isIos
                              ? [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoListTile(
                                      padding: const EdgeInsets.all(12),
                                      backgroundColorActivated:
                                          Colors.grey.shade700,
                                      leading: FaIcon(
                                        FontAwesomeIcons.image,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'changepic'.tr,
                                      ),
                                      onTap: () =>
                                          controller.changeProfilePic(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoListTile(
                                      padding: const EdgeInsets.all(12),
                                      backgroundColorActivated:
                                          Colors.grey.shade700,
                                      leading: FaIcon(
                                        FontAwesomeIcons.language,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'changelanguage'.tr,
                                      ),
                                      onTap: () => controller.lanChange(),
                                      trailing: CustomText(
                                        text: controller.model.language
                                            .toString()
                                            .substring(0, 2),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoListTile(
                                      padding: const EdgeInsets.all(12),
                                      backgroundColorActivated:
                                          Colors.grey.shade700,
                                      leading: FaIcon(
                                        FontAwesomeIcons.user,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'changeuser'.tr,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoListTile(
                                      padding: const EdgeInsets.all(12),
                                      backgroundColorActivated:
                                          Colors.grey.shade700,
                                      leading: FaIcon(
                                        FontAwesomeIcons.moon,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'darkmode'.tr,
                                      ),
                                      onTap: () => controller.themeChange(),
                                      trailing: Switch(
                                        value: controller.model.theme ==
                                            ChosenTheme.dark,
                                        onChanged: (val) =>
                                            controller.themeChange(),
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoListTile(
                                      padding: const EdgeInsets.all(12),
                                      backgroundColorActivated:
                                          Colors.grey.shade700,
                                      leading: FaIcon(
                                        FontAwesomeIcons.circleInfo,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'about'.tr,
                                      ),
                                      onTap: () => controller.about(
                                        context: context,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                                text: 'filmmer'.tr,
                                                size: constraints.maxWidth *
                                                    0.04),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: CustomText(
                                                  text:
                                                      '${"dev".tr} : ${"devname".tr}',
                                                  size: constraints.maxWidth *
                                                      0.04),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            context: context,
                                                            url:
                                                                'https://twitter.com/ESMAELNOOR'),
                                                    child: Icon(
                                                      FontAwesomeIcons.twitter,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            context: context,
                                                            url:
                                                                'https://github.com/Ismail-Hagg'),
                                                    child: Icon(
                                                      FontAwesomeIcons.github,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            context: context,
                                                            url:
                                                                'https://wa.me/966500258717'),
                                                    child: Icon(
                                                      FontAwesomeIcons.whatsapp,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            context: context,
                                                            url:
                                                                'tel:+966500258717'),
                                                    child: Icon(
                                                      FontAwesomeIcons.phone,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CupertinoListTile(
                                      padding: const EdgeInsets.all(12),
                                      backgroundColorActivated:
                                          Colors.grey.shade700,
                                      leading: FaIcon(
                                        FontAwesomeIcons.rightFromBracket,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'logout'.tr,
                                      ),
                                      onTap: () =>
                                          controller.logOut(context: context),
                                    ),
                                  ),
                                ]
                              : [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: FaIcon(
                                        FontAwesomeIcons.image,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'changepic'.tr,
                                      ),
                                      onTap: () =>
                                          controller.changeProfilePic(),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: FaIcon(
                                        FontAwesomeIcons.language,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'changelanguage'.tr,
                                      ),
                                      onTap: () => controller.lanChange(),
                                      trailing: CustomText(
                                        text: controller.model.language
                                            .toString()
                                            .substring(0, 2),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: FaIcon(
                                        FontAwesomeIcons.user,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'changeuser'.tr,
                                      ),
                                      onTap: () {},
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: FaIcon(
                                        FontAwesomeIcons.moon,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'darkmode'.tr,
                                      ),
                                      onTap: () => controller.themeChange(),
                                      trailing: Switch(
                                        value: controller.model.theme ==
                                            ChosenTheme.dark,
                                        onChanged: (val) =>
                                            controller.themeChange(),
                                        activeColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: FaIcon(
                                        FontAwesomeIcons.circleInfo,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                      title: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: 'about'.tr,
                                      ),
                                      onTap: () => controller.about(
                                        context: context,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                                text: 'filmmer'.tr,
                                                size: constraints.maxWidth *
                                                    0.04),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: CustomText(
                                                  text:
                                                      '${"dev".tr} : ${"devname".tr}',
                                                  size: constraints.maxWidth *
                                                      0.04),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            context: context,
                                                            url:
                                                                'https://twitter.com/ESMAELNOOR'),
                                                    child: Icon(
                                                      FontAwesomeIcons.twitter,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            context: context,
                                                            url:
                                                                'https://github.com/Ismail-Hagg'),
                                                    child: Icon(
                                                      FontAwesomeIcons.github,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            context: context,
                                                            url:
                                                                'https://wa.me/966500258717'),
                                                    child: Icon(
                                                      FontAwesomeIcons.whatsapp,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        controller.launcherUse(
                                                            context: context,
                                                            url:
                                                                'tel:+966500258717'),
                                                    child: Icon(
                                                      FontAwesomeIcons.phone,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: width * 0.08,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                        leading: FaIcon(
                                          FontAwesomeIcons.rightFromBracket,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                        title: CustomText(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          text: 'logout'.tr,
                                        ),
                                        onTap: () => controller.logOut(
                                            context: context)),
                                  ),
                                ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
