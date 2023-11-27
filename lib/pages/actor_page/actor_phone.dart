import 'package:cineverse/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActorPhone extends StatelessWidget {
  const ActorPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: CustomText(
          text: 'biog'.tr,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
