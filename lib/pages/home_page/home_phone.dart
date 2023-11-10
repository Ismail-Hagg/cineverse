import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/widgets/avatar_widget.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:cineverse/widgets/notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePhone extends StatelessWidget {
  const HomePhone({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final HomeController controller = Get.put(HomeController());
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            double height = constraints.maxHeight;
            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 24.0, horizontal: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            LoginInput(
                              textSize: 15,
                              onTap: () => authController.themeSwich(),
                              height: width * 0.115,
                              width: width * 0.82,
                              obscure: false,
                              isSelected: false,
                              readOnly: true,
                              hintNoLable: 'search'.tr,
                              leadingIcon:
                                  const Icon(FontAwesomeIcons.magnifyingGlass),
                            ),
                            NotificationWidget(
                              isNotify: true,
                              mainWidget: Icon(
                                Icons.notifications,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              notificationColor: Colors.red,
                              top: 2,
                              right: 2,
                              height: width * 0.02,
                              width: width * 0.02,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          Positioned(
            bottom: 0,
            child: Container(
              height: height * 0.0125,
              width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    blackColor.withOpacity(0.1),
                    Colors.transparent
                  ])),
            ),
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<HomeController>(
        init: Get.find<HomeController>(),
        builder: (controller) => FittedBox(
          child: SalomonBottomBar(
            onTap: (page) => controller.indexChange(index: page),
            currentIndex: controller.pageIndex,
            backgroundColor: Theme.of(context).colorScheme.background,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            items: [
              SalomonBottomBarItem(
                icon: const FaIcon(FontAwesomeIcons.house),
                title: CustomText(text: 'home'.tr),
              ),
              SalomonBottomBarItem(
                icon: const FaIcon(FontAwesomeIcons.list),
                title: CustomText(text: 'watchList'.tr),
              ),
              SalomonBottomBarItem(
                icon: const FaIcon(FontAwesomeIcons.heart),
                title: CustomText(text: 'favourite'.tr),
              ),
              SalomonBottomBarItem(
                icon: const FaIcon(FontAwesomeIcons.tv),
                title: CustomText(text: 'keeping'.tr),
              ),
              SalomonBottomBarItem(
                icon: NotificationWidget(
                    top: 0,
                    right: 0,
                    mainWidget: const Icon(Icons.chat),
                    notificationColor: Colors.red,
                    height: width * 0.025,
                    width: width * 0.025,
                    isNotify: true),
                title: CustomText(text: 'chats'.tr),
              ),
              SalomonBottomBarItem(
                icon: Avatar(
                  width: width * 0.08,
                  height: width * 0.08,
                  isBorder: false,
                  type: authController.userModel.avatarType as AvatarType,
                  boxFit: BoxFit.cover,
                  shadow: false,
                  link: authController.userModel.avatarType == AvatarType.local
                      ? authController.userModel.localPicPath
                      : authController.userModel.avatarType == AvatarType.online
                          ? authController.userModel.onlinePicPath
                          : '',
                  isIos: authController.platform == TargetPlatform.iOS,
                  iconAndroid: FontAwesomeIcons.user,
                  iconIos: CupertinoIcons.person,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  iconColor: Theme.of(context).colorScheme.secondary,
                  iconSize: width * 0.065,
                ),
                title: CustomText(text: 'profile'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
