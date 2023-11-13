import 'package:carousel_slider/carousel_slider.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/widgets/avatar_widget.dart';
import 'package:cineverse/widgets/content_scrolling.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:cineverse/widgets/movie_widget.dart';
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
    final HomeController controller = Get.put(HomeController());
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GetBuilder(
        init: Get.find<HomeController>(),
        builder: (control) => Stack(
          children: [
            control.pages[control.pageIndex],
            Positioned(
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.0125,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [blackColor.withOpacity(0.1), Colors.transparent],
                  ),
                ),
              ),
            ),
          ],
        ),
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
                icon: NotificationWidget(
                    top: 0,
                    right: 0,
                    mainWidget: const FaIcon(FontAwesomeIcons.tv),
                    notificationColor: Colors.red,
                    height: width * 0.025,
                    width: width * 0.025,
                    isNotify: true),
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

class HomeTap extends StatelessWidget {
  const HomeTap({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://i.pinimg.com/originals/62/2d/48/622d4881be7d13fcd925a880bf439806.jpg',
      'https://www.themoviedb.org/t/p/w1280/e7Jvsry47JJQruuezjU2X1Z6J77.jpg',
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
    ];
    final AuthController authController = Get.find<AuthController>();
    final HomeController controller = Get.find<HomeController>();
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: width,
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
                          leadingIcon: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => controller.apiCall(),
                          child: NotificationWidget(
                            isNotify: true,
                            mainWidget: Icon(
                              Icons.notifications,
                              size: width * 0.065,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            notificationColor: Colors.red,
                            top: 2,
                            right: 2,
                            height: width * 0.02,
                            width: width * 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ContentScrolling(
                    title: 'trend'.tr,
                    weight: FontWeight.bold,
                    more: true,
                    titleSize: 18,
                    isIos: authController.platform == TargetPlatform.iOS,
                    mainWidget: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                      ),
                      items: imgList
                          .map((item) => ImageNetWork(
                                shadow: false,
                                link: item,
                                width: width,
                                height: (width * 0.4) * 1.3,
                              ))
                          .toList(),
                    ),
                  ),
                  // upcoming movies
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContentScrolling(
                      isIos: authController.platform == TargetPlatform.iOS,
                      title: 'upcoming'.tr,
                      weight: FontWeight.bold,
                      titleSize: 18,
                      more: true,
                      mainWidget: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            60,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageNetWork(
                                link: imgList[0],
                                height: (width * 0.4) * 1.3,
                                width: width * 0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // popular movies
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContentScrolling(
                      isIos: authController.platform == TargetPlatform.iOS,
                      title: 'popularMovies'.tr,
                      weight: FontWeight.bold,
                      titleSize: 18,
                      more: true,
                      mainWidget: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            controller.loading == 1
                                ? 10
                                : controller.links.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: controller.loading == 1
                                  ? MovieWidget(
                                      width: width * 0.35,
                                      height: (width * 0.4) * 1.3,
                                      link: '',
                                      provider: Image.asset('name').image,
                                      shimmer: true,
                                      shadow: false)
                                  : ImageNetWork(
                                      link:
                                          'https://www.themoviedb.org/t/p/w1280/${controller.links[index]}',
                                      height: (width * 0.4) * 1.3,
                                      width: width * 0.35,
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // popular shows
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContentScrolling(
                      isIos: authController.platform == TargetPlatform.iOS,
                      title: 'popularShows'.tr,
                      weight: FontWeight.bold,
                      titleSize: 18,
                      more: true,
                      mainWidget: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            60,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageNetWork(
                                link: imgList[0],
                                height: (width * 0.4) * 1.3,
                                width: width * 0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // top rated movies
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContentScrolling(
                      isIos: authController.platform == TargetPlatform.iOS,
                      title: 'topMovies'.tr,
                      weight: FontWeight.bold,
                      titleSize: 18,
                      more: true,
                      mainWidget: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            60,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageNetWork(
                                link: imgList[0],
                                height: (width * 0.4) * 1.3,
                                width: width * 0.35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // top rated shows
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ContentScrolling(
                      isIos: authController.platform == TargetPlatform.iOS,
                      title: 'topShowa'.tr,
                      weight: FontWeight.bold,
                      titleSize: 18,
                      more: true,
                      mainWidget: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            60,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ImageNetWork(
                                height: (width * 0.4) * 1.3,
                                width: width * 0.35,
                                link: imgList[3],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
