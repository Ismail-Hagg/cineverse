import 'package:cineverse/pages/chats_page/chat_desktop.dart';
import 'package:cineverse/pages/chats_page/chat_phone.dart';
import 'package:cineverse/pages/chats_page/chat_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class ChatController extends StatelessWidget {
  const ChatController({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const ChatPhone()
        : width > phoneSize && width <= tabletSize
            ? const ChatTablet()
            : const ChatDesktop();
  }
}
