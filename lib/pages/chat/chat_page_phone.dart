import 'package:cineverse/controllers/chat_page_controller.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';

class ChatPagePhone extends StatelessWidget {
  const ChatPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatPageController controller = Get.find<ChatPageController>();
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
        title: CustomText(
          text: Get.find<ChatPageController>().otherUser!.userName.toString(),
          flow: TextOverflow.ellipsis,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.straem,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: CustomText(
                text: 'error'.tr,
                color: Theme.of(context).colorScheme.primary,
                size: 25,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: SizedBox(
              width: width * 0.1,
              height: width * 0.1,
              child: FittedBox(
                child: controller.isIos
                    ? CupertinoActivityIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary),
              ),
            ));
          }

          snapshot.data!.docs.isNotEmpty
              ? controller.getMessages(snapshot.data!.docs[0]['messages'])
              : null;

          controller.clearIsUpdated();
          return GetBuilder<ChatPageController>(
              init: Get.find<ChatPageController>(),
              builder: (thing) => Chat(
                    messages: controller.messages,
                    onSendPressed: controller.sendMessage,
                    user: thing.user,
                    showUserAvatars: false,
                    showUserNames: false,
                    scrollPhysics: const BouncingScrollPhysics(),
                    useTopSafeAreaInset: true,
                    disableImageGallery: true,
                    theme: DarkChatTheme(
                      seenIcon: const Icon(Icons.hourglass_bottom),
                      inputBackgroundColor:
                          controller.userModel.theme == ChosenTheme.dark
                              ? const Color.fromARGB(255, 92, 88, 88)
                              : const Color.fromARGB(255, 201, 198, 198),
                      primaryColor:
                          controller.userModel.theme == ChosenTheme.dark
                              ? const Color.fromARGB(255, 92, 88, 88)
                              : const Color.fromARGB(255, 201, 198, 198),
                      secondaryColor:
                          controller.userModel.theme == ChosenTheme.dark
                              ? const Color.fromARGB(255, 92, 88, 88)
                              : const Color.fromARGB(255, 201, 198, 198),
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                  ));
        },
      ),
    );
  }
}
