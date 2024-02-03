import 'package:cineverse/controllers/keeping_controller.dart';
import 'package:cineverse/models/episode_omdel.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/episode_keeping_widget.dart';
import 'package:cineverse/widgets/keeping_bottom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeepingPhone extends StatelessWidget {
  const KeepingPhone({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: CustomText(
          text: 'keeping'.tr,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var width = constraints.maxWidth;
        return GetBuilder<KeepingController>(
          init: Get.find<KeepingController>(),
          builder: (controller) {
            return controller.loading
                ? Center(
                    child: SizedBox(
                      width: width * 0.1,
                      height: width * 0.1,
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
                        controller.lsit.length,
                        (index) {
                          EpisodeModeL model = controller.lsit[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onLongPress: () =>
                                  controller.keepDelete(index: index),
                              onTap: () => controller.openBottom(
                                  index: index,
                                  context: context,
                                  widget: GetBuilder<KeepingController>(
                                    init: Get.find<KeepingController>(),
                                    builder: (_) {
                                      return KeepingBottom(
                                        catchup: () =>
                                            controller.fastCatch(index: index),
                                        delete: () =>
                                            controller.keepDelete(index: index),
                                        edit: () => controller.afterEdit(
                                          index: index,
                                        ),
                                        epAdd: () => controller.editing(
                                            index: index,
                                            add: true,
                                            episode: true),
                                        epMin: () => controller.editing(
                                            index: index,
                                            add: false,
                                            episode: true),
                                        seAdd: () => controller.editing(
                                            index: index,
                                            add: true,
                                            episode: false),
                                        seMin: () => controller.editing(
                                            index: index,
                                            add: false,
                                            episode: false),
                                        nextEpisode: model.nextepisode as int,
                                        nextSeason: model.nextSeason as int,
                                        mySeason: model.mySeason as int,
                                        myEpisode: model.myEpisode as int,
                                        season: model.season as int,
                                        episode: model.episode as int,
                                        nextDate:
                                            model.nextEpisodeDate.toString(),
                                        statut: model.status.toString(),
                                        isIos: controller.isIos,
                                        width: width,
                                      );
                                    },
                                  )),
                              child: EpisodeKeeping(
                                isUpdated: model.isUpdated as bool,
                                even: model.myEpisode == model.episode &&
                                    model.mySeason == model.season,
                                episode: model.myEpisode as int,
                                season: model.mySeason as int,
                                homeNav: () => controller.showNav(model: model),
                                isEnglish: controller.userModel.language
                                        .toString()
                                        .substring(0, 2) ==
                                    'en',
                                nextDate: model.nextEpisodeDate.toString(),
                                title: model.name.toString(),
                                width: width,
                                link: imagebase + model.pic.toString(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
          },
        );
      }),
    );
  }
}
