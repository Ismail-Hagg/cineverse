import 'package:carousel_slider/carousel_slider.dart';
import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/models/result_model.dart';
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
    final AuthController authController = Get.find<AuthController>();
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
                          isSearch: true,
                          textSize: 15,
                          onTap: () => Get.find<HomeController>().navToSearch(
                              model:
                                  ResultModel(isError: true, errorMessage: ''),
                              isSearch: true,
                              title: 'title',
                              link: 'link'),
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
                          onTap: () => authController.signOut(),
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
                  GetBuilder<HomeController>(
                    init: Get.find<HomeController>(),
                    builder: (trend) => ContentScrolling(
                      function: () => trend.navToSearch(
                          model: trend.trendings,
                          isSearch: false,
                          title: 'trend'.tr,
                          link: trend.urls[0]),
                      title: 'trend'.tr,
                      weight: FontWeight.bold,
                      more: true,
                      load: trend.trendings.isError == false ? null : true,
                      reload: () => trend.apiCall(),
                      titleSize: 18,
                      isIos: authController.platform == TargetPlatform.iOS,
                      mainWidget: CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: trend.loading == 0 &&
                              trend.trendings.isError == false,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                        ),
                        items: List.generate(
                          trend.loading == 1
                              ? 10
                              : trend.trendings.isError == false
                                  ? trend.trendings.results!.length
                                  : 10,
                          (index) => Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: trend.loading == 1 ||
                                    trend.trendings.isError == true
                                ? MovieWidget(
                                    borderColor: Colors.transparent,
                                    width: width,
                                    height: (width * 0.4) * 1.3,
                                    link: '',
                                    provider: Image.asset('name').image,
                                    shimmer: true,
                                    shadow: false)
                                : ImageNetWork(
                                    function: () => trend.navToDetale(
                                        res: trend.trendings.results![index]),
                                    shadow: false,
                                    link: imagebase +
                                        trend.trendings.results![index]
                                            .posterPath
                                            .toString(),
                                    width: width,
                                    height: (width * 0.4) * 1.3,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // upcoming movies
                  GetBuilder<HomeController>(
                    init: Get.find<HomeController>(),
                    builder: (upcoming) => ContentScrolling(
                      function: () => upcoming.navToSearch(
                          model: upcoming.upcomingMovies,
                          isSearch: false,
                          title: 'upcoming'.tr,
                          link: upcoming.urls[1]),
                      load: upcoming.upcomingMovies.isError == false
                          ? null
                          : true,
                      reload: () => upcoming.apiCall(),
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
                            upcoming.loading == 1
                                ? 10
                                : upcoming.upcomingMovies.isError == false
                                    ? upcoming.upcomingMovies.results!.length
                                    : 10,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: upcoming.loading == 1 ||
                                      upcoming.upcomingMovies.isError == true
                                  ? MovieWidget(
                                      borderColor: Colors.transparent,
                                      width: width * 0.35,
                                      height: (width * 0.4) * 1.3,
                                      link: '',
                                      provider: Image.asset('name').image,
                                      shimmer: true,
                                      shadow: false)
                                  : ImageNetWork(
                                      function: () => upcoming.navToDetale(
                                          res: upcoming
                                              .upcomingMovies.results![index]),
                                      link: imagebase +
                                          upcoming.upcomingMovies
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
                  ),
                  // popular movies
                  GetBuilder<HomeController>(
                    init: Get.find<HomeController>(),
                    builder: (builder) => ContentScrolling(
                      function: () => builder.navToSearch(
                          model: builder.popularMovies,
                          isSearch: false,
                          title: 'popularMovies'.tr,
                          link: builder.urls[2]),
                      load:
                          builder.popularMovies.isError == false ? null : true,
                      reload: () => builder.apiCall(),
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
                            builder.loading == 1
                                ? 10
                                : builder.popularMovies.isError == false
                                    ? builder.popularMovies.results!.length
                                    : 10,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: builder.loading == 1 ||
                                      builder.popularMovies.isError == true
                                  ? MovieWidget(
                                      borderColor: Colors.transparent,
                                      width: width * 0.35,
                                      height: (width * 0.4) * 1.3,
                                      link: '',
                                      provider: Image.asset('name').image,
                                      shimmer: true,
                                      shadow: false)
                                  : ImageNetWork(
                                      function: () => builder.navToDetale(
                                          res: builder
                                              .popularMovies.results![index]),
                                      link: imagebase +
                                          builder.popularMovies.results![index]
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
                  ),
                  // popular shows
                  GetBuilder<HomeController>(
                    init: Get.find<HomeController>(),
                    builder: (popShow) => ContentScrolling(
                      function: () => popShow.navToSearch(
                          model: popShow.popularShows,
                          isSearch: false,
                          title: 'popularShows'.tr,
                          link: popShow.urls[3]),
                      load: popShow.popularShows.isError == false ? null : true,
                      reload: () => popShow.apiCall(),
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
                            popShow.loading == 1
                                ? 10
                                : popShow.popularShows.isError == false
                                    ? popShow.popularShows.results!.length
                                    : 10,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: popShow.loading == 1 ||
                                      popShow.popularShows.isError == true
                                  ? MovieWidget(
                                      borderColor: Colors.transparent,
                                      width: width * 0.35,
                                      height: (width * 0.4) * 1.3,
                                      link: '',
                                      provider: Image.asset('name').image,
                                      shimmer: true,
                                      shadow: false)
                                  : ImageNetWork(
                                      function: () => popShow.navToDetale(
                                          res: popShow
                                              .popularShows.results![index]),
                                      link: imagebase +
                                          popShow.popularShows.results![index]
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
                  ),
                  // top rated movies
                  GetBuilder<HomeController>(
                    init: Get.find<HomeController>(),
                    builder: (topMovie) => ContentScrolling(
                      function: () => topMovie.navToSearch(
                          model: topMovie.topMovies,
                          isSearch: false,
                          title: 'topMovies'.tr,
                          link: topMovie.urls[4]),
                      load: topMovie.topMovies.isError == false ? null : true,
                      reload: () => topMovie.apiCall(),
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
                            topMovie.loading == 1
                                ? 10
                                : topMovie.topMovies.isError == false
                                    ? topMovie.topMovies.results!.length
                                    : 10,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: topMovie.loading == 1 ||
                                      topMovie.topMovies.isError == true
                                  ? MovieWidget(
                                      borderColor: Colors.transparent,
                                      width: width * 0.35,
                                      height: (width * 0.4) * 1.3,
                                      link: '',
                                      provider: Image.asset('name').image,
                                      shimmer: true,
                                      shadow: false)
                                  : ImageNetWork(
                                      function: () => topMovie.navToDetale(
                                          res: topMovie
                                              .topMovies.results![index]),
                                      link: imagebase +
                                          topMovie.topMovies.results![index]
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
                  ),
                  // top rated shows
                  GetBuilder<HomeController>(
                    init: Get.find<HomeController>(),
                    builder: (topShow) => ContentScrolling(
                      function: () => topShow.navToSearch(
                          model: topShow.topShows,
                          isSearch: false,
                          title: 'topShowa'.tr,
                          link: topShow.urls[5]),
                      load: topShow.topShows.isError == false ? null : true,
                      reload: () => topShow.apiCall(),
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
                            topShow.loading == 1
                                ? 10
                                : topShow.topShows.isError == false
                                    ? topShow.topShows.results!.length
                                    : 10,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: topShow.loading == 1 ||
                                      topShow.topShows.isError == true
                                  ? MovieWidget(
                                      borderColor: Colors.transparent,
                                      width: width * 0.35,
                                      height: (width * 0.4) * 1.3,
                                      link: '',
                                      provider: Image.asset('name').image,
                                      shimmer: true,
                                      shadow: false)
                                  : ImageNetWork(
                                      function: () => topShow.navToDetale(
                                          res:
                                              topShow.topShows.results![index]),
                                      link: imagebase +
                                          topShow.topShows.results![index]
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
