import 'package:cineverse/controllers/follow_controllere.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FollowPhone extends StatelessWidget {
  const FollowPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: CustomText(
          text: Get.find<FollowController>().title,
          color: Theme.of(context).colorScheme.primary,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
      ),
      body: GetBuilder<FollowController>(
        init: Get.find<FollowController>(),
        builder: (controller) => LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            return controller.loading
                ? Center(
                    child: SizedBox(
                      height: width * 0.1,
                      width: width * 0.1,
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
                    child: Column(
                      children: List.generate(
                        controller.users.length,
                        (index) {
                          return controller.isIos
                              ? Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CupertinoListTile(
                                    backgroundColorActivated:
                                        Colors.grey.withOpacity(0.3),
                                    onTap: () =>
                                        controller.navProfile(index: index),
                                    leadingSize: width * 0.15,
                                    leading: ImageNetWork(
                                        circle: true,
                                        border: null,
                                        link: controller
                                            .users[index].onlinePicPath
                                            .toString(),
                                        width: width * 0.2,
                                        height: width * 0.2),
                                    title: CustomText(
                                      flow: TextOverflow.ellipsis,
                                      maxline: 1,
                                      text: controller.users[index].userName
                                          .toString(),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    onTap: () =>
                                        controller.navProfile(index: index),
                                    leading: ImageNetWork(
                                        circle: true,
                                        border: null,
                                        link: controller
                                            .users[index].onlinePicPath
                                            .toString(),
                                        width: width * 0.2,
                                        height: width * 0.2),
                                    title: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4),
                                      child: CustomText(
                                        size: width * 0.04,
                                        flow: TextOverflow.ellipsis,
                                        maxline: 1,
                                        text: controller.users[index].userName
                                            .toString(),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
