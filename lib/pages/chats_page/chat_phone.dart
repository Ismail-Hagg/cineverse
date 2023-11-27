import 'package:cineverse/controllers/chat_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPhone extends StatelessWidget {
  const ChatPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(Get.find<ChatController>().rec),
      ),
    );
  }
}
