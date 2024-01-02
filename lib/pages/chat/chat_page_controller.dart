import 'package:cineverse/controllers/chat_page_controller.dart';
import 'package:cineverse/pages/chat/chat_page_desktop.dart';
import 'package:cineverse/pages/chat/chat_page_phone.dart';
import 'package:cineverse/pages/chat/chat_page_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatPageViewController extends StatelessWidget {
  const ChatPageViewController({super.key});

  @override
  Widget build(BuildContext context) {
    ChatPageController controller = Get.put(ChatPageController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const ChatPagePhone()
        : width > phoneSize && width <= tabletSize
            ? const ChatPageTablet()
            : const ChatPageDesktop();
  }
}
