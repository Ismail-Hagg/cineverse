import 'package:cineverse/controllers/notifications_controller.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsPhone extends StatelessWidget {
  const NotificationsPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'notifications'.tr,
          color: Theme.of(context).colorScheme.primary,
        ),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
      ),
      body: GetBuilder<NotificationsController>(
        init: Get.find<NotificationsController>(),
        builder: (controller) {
          return LayoutBuilder(
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
                          controller.notifications.length,
                          (index) {
                            return controller.isIos
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: CupertinoListTile(
                                      trailing: CustomText(
                                        size: width * 0.03,
                                        color: controller.notifications[index]
                                                    .open ==
                                                true
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        text: controller.notifications[index]
                                                    .time !=
                                                null
                                            ? timeAgo(controller
                                                .notifications[index]
                                                .time as DateTime)
                                            : '',
                                      ),
                                      backgroundColorActivated:
                                          Colors.grey.withOpacity(0.3),
                                      onTap: () =>
                                          controller.clicked(index: index),
                                      leadingSize: width * 0.15,
                                      leading: GestureDetector(
                                        onTap: () => controller.profileNav(
                                            index: index,
                                            type: controller
                                                .notifications[index].type,
                                            link: controller
                                                .notifications[index].userImage,
                                            userId: controller
                                                .notifications[index].userId,
                                            userName: controller
                                                .notifications[index].userName),
                                        child: ImageNetWork(
                                            circle: true,
                                            border: controller
                                                        .notifications[index]
                                                        .open ==
                                                    true
                                                ? Colors.transparent
                                                : null,
                                            link: controller
                                                .notifications[index].userImage,
                                            width: width * 0.2,
                                            height: width * 0.2),
                                      ),
                                      title: CustomText(
                                        flow: TextOverflow.ellipsis,
                                        maxline: 1,
                                        text: controller
                                            .notifications[index].userName,
                                        color: controller.notifications[index]
                                                    .open ==
                                                true
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                      ),
                                      subtitle: CustomText(
                                        flow: TextOverflow.ellipsis,
                                        maxline: 2,
                                        text: controller.notifications[index]
                                            .notificationBody,
                                        color: controller.notifications[index]
                                                    .open ==
                                                true
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: ListTile(
                                      trailing: CustomText(
                                        size: width * 0.03,
                                        color: controller.notifications[index]
                                                    .open ==
                                                true
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        text: controller.notifications[index]
                                                    .time !=
                                                null
                                            ? timeAgo(controller
                                                .notifications[index]
                                                .time as DateTime)
                                            : '',
                                      ),
                                      onTap: () =>
                                          controller.clicked(index: index),
                                      leading: GestureDetector(
                                        onTap: () => controller.profileNav(
                                            index: index,
                                            type: controller
                                                .notifications[index].type,
                                            link: controller
                                                .notifications[index].userImage,
                                            userId: controller
                                                .notifications[index].userId,
                                            userName: controller
                                                .notifications[index].userName),
                                        child: ImageNetWork(
                                            circle: true,
                                            border: controller
                                                        .notifications[index]
                                                        .open ==
                                                    true
                                                ? Colors.transparent
                                                : null,
                                            link: controller
                                                .notifications[index].userImage,
                                            width: width * 0.2,
                                            height: width * 0.2),
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: CustomText(
                                          size: width * 0.04,
                                          flow: TextOverflow.ellipsis,
                                          maxline: 1,
                                          text: controller
                                              .notifications[index].userName,
                                          color: controller.notifications[index]
                                                      .open ==
                                                  true
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                        ),
                                      ),
                                      subtitle: CustomText(
                                        size: width * 0.03,
                                        flow: TextOverflow.ellipsis,
                                        maxline: 2,
                                        text: controller.notifications[index]
                                            .notificationBody,
                                        color: controller.notifications[index]
                                                    .open ==
                                                true
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Theme.of(context)
                                                .colorScheme
                                                .primary,
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ),
                    );
            },
          );
        },
      ),
    );
  }
}
