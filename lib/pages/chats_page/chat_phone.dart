import 'package:cineverse/controllers/chat_controller.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPhone extends StatelessWidget {
  const ChatPhone({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController controller = Get.find<ChatController>();
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          centerTitle: true,
          elevation: 0,
          title: CustomText(
            text: 'chats'.tr,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double width = constraints.maxWidth;
            return StreamBuilder(
                stream: controller.straem,
                builder: (contex, snapshot) {
                  if (snapshot.hasData) {
                    controller.gatherData(chats: snapshot.data!.docs);
                  }
                  return snapshot.connectionState == ConnectionState.waiting
                      ? Center(
                          child: SizedBox(
                            height: width * 0.1,
                            width: width * 0.1,
                            child: FittedBox(
                              child: controller.isIos
                                  ? CupertinoActivityIndicator(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  : CircularProgressIndicator(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                            ),
                          ),
                        )
                      : snapshot.hasError
                          ? Center(
                              child: SizedBox(
                                height: width * 0.1,
                                width: width * 0.1,
                                child: FittedBox(
                                    child: CustomText(
                                  text: 'error'.tr,
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                children: List.generate(
                                  controller.lst.length,
                                  (index) {
                                    return controller.isIos
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: CupertinoListTile(
                                              trailing: CustomText(
                                                color: controller.lst[index]
                                                            .isUpdated ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                text: timeAgo(controller
                                                    .lst[index].change
                                                    .toDate()),
                                              ),
                                              backgroundColorActivated:
                                                  Colors.grey.withOpacity(0.3),
                                              onTap: () => controller.navChat(
                                                  index: index),
                                              leadingSize: width * 0.15,
                                              leading: GestureDetector(
                                                onTap: () => controller
                                                    .navProfile(index: index),
                                                child: ImageNetWork(
                                                    circle: true,
                                                    border: controller
                                                                .lst[index]
                                                                .isUpdated ==
                                                            true
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    link: controller
                                                        .lst[index].onlinePath,
                                                    width: width * 0.2,
                                                    height: width * 0.2),
                                              ),
                                              title: CustomText(
                                                flow: TextOverflow.ellipsis,
                                                maxline: 1,
                                                text: controller
                                                    .lst[index].userNsme,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                              subtitle: CustomText(
                                                flow: TextOverflow.ellipsis,
                                                maxline: 2,
                                                text: controller.lst[index]
                                                    .messages.last['text'],
                                                color: controller.lst[index]
                                                            .isUpdated ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: ListTile(
                                              trailing: CustomText(
                                                color: controller.lst[index]
                                                            .isUpdated ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                text: timeAgo(controller
                                                    .lst[index].change
                                                    .toDate()),
                                              ),
                                              onTap: () => controller.navChat(
                                                  index: index),
                                              leading: GestureDetector(
                                                onTap: () => controller
                                                    .navProfile(index: index),
                                                child: ImageNetWork(
                                                    circle: true,
                                                    border: controller
                                                                .lst[index]
                                                                .isUpdated ==
                                                            true
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    link: controller
                                                        .lst[index].onlinePath,
                                                    width: width * 0.2,
                                                    height: width * 0.2),
                                              ),
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4),
                                                child: CustomText(
                                                  size: width * 0.04,
                                                  flow: TextOverflow.ellipsis,
                                                  maxline: 1,
                                                  text: controller
                                                      .lst[index].userNsme,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ),
                                              ),
                                              subtitle: CustomText(
                                                size: width * 0.03,
                                                flow: TextOverflow.ellipsis,
                                                maxline: 2,
                                                text: controller.lst[index]
                                                    .messages.last['text'],
                                                color: controller.lst[index]
                                                            .isUpdated ==
                                                        true
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),
                            );
                });
          },
        ));
  }
}
