import 'package:cineverse/controllers/chat_controller.dart';
import 'package:cineverse/pages/chats_page/chat_desktop.dart';
import 'package:cineverse/pages/chats_page/chat_phone.dart';
import 'package:cineverse/pages/chats_page/chat_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatViewController extends StatelessWidget {
  const ChatViewController({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const ChatPhone()
        : width > phoneSize && width <= tabletSize
            ? const ChatTablet()
            : const ChatDesktop();
  }
}
