import 'package:cineverse/controllers/actor_controller.dart';
import 'package:cineverse/pages/actor_page/actor_desktop.dart';
import 'package:cineverse/pages/actor_page/actor_phone.dart';
import 'package:cineverse/pages/actor_page/actor_tablet.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ActorViewController extends StatelessWidget {
  const ActorViewController({super.key});

  @override
  Widget build(BuildContext context) {
    final ActorController controller = Get.put(ActorController());
    double width = MediaQuery.of(context).size.width;
    return width <= phoneSize
        ? const ActorPhone()
        : width > phoneSize && width <= tabletSize
            ? const ActorTablet()
            : const ActorDesktop();
  }
}
