import 'package:cineverse/controllers/explore_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/utils/genres.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ExploreController controller = Get.put(ExploreController());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: CustomText(
          text: 'explore'.tr,
          color: Theme.of(context).colorScheme.primary,
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        actions: [
          controller.isIos
              ? CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: FaIcon(
                    color: Theme.of(context).colorScheme.primary,
                    FontAwesomeIcons.filter,
                  ),
                  onPressed: () => controller.openBottom(
                      context: context, widget: const BottomWidget()),
                )
              : IconButton(
                  splashRadius: 15,
                  onPressed: () => controller.openBottom(
                      context: context, widget: const BottomWidget()),
                  icon: FaIcon(
                    color: Theme.of(context).colorScheme.primary,
                    FontAwesomeIcons.filter,
                  ),
                ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          return GetBuilder<ExploreController>(
            init: Get.find<ExploreController>(),
            builder: (controller) {
              return controller.mainLoader == true
                  ? Center(
                      child: SizedBox(
                        height: width * 0.15,
                        width: width * 0.15,
                        child: FittedBox(
                          child: controller.isIos
                              ? CupertinoActivityIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    )
                  : controller.model.isError != null
                      ? controller.model.isError == true
                          ? Center(
                              child: SizedBox(
                                height: width,
                                width: width,
                                child: Column(
                                  children: [
                                    CustomText(
                                      text: 'error'.tr,
                                      size: width * 0.056,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    CustomText(
                                      text: controller.model.errorMessage
                                          .toString(),
                                      size: width * 0.056,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : controller.model.totalResults == 0 ||
                                  controller.model.results!.isEmpty
                              ? Center(
                                  child: SizedBox(
                                    height: width * 0.4,
                                    width: width * 0.5,
                                    child: Center(
                                      child: CustomText(
                                        text: 'res'.tr,
                                        size: width * 0.056,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ),
                                )
                              : SingleChildScrollView(
                                  controller: controller.scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  child: SizedBox(
                                    width: width,
                                    child: Wrap(
                                      runAlignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      spacing: 2,
                                      runSpacing: 2,
                                      children: List.generate(
                                        controller.model.results!.length,
                                        (index) => GestureDetector(
                                          onTap: () =>
                                              Get.find<HomeController>()
                                                  .navToDetale(
                                                      res: controller.model
                                                          .results![index]),
                                          child: controller
                                                      .model
                                                      .results![index]
                                                      .mediaType ==
                                                  'person'
                                              ? Hero(
                                                  tag: controller
                                                      .model.results![index].id
                                                      .toString(),
                                                  child: ImageNetWork(
                                                      shadow: false,
                                                      link: imagebase +
                                                          controller
                                                              .model
                                                              .results![index]
                                                              .posterPath
                                                              .toString(),
                                                      width: width * 0.32,
                                                      height: width * 0.47))
                                              : ImageNetWork(
                                                  shadow: false,
                                                  link: imagebase +
                                                      controller
                                                          .model
                                                          .results![index]
                                                          .posterPath
                                                          .toString(),
                                                  width: width * 0.32,
                                                  height: width * 0.47),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                      : Container();
            },
          );
        },
      ),
    );
  }
}

class BottomWidget extends StatelessWidget {
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return GetBuilder<ExploreController>(
      init: Get.find<ExploreController>(),
      builder: (controller) {
        return SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (width * 0.21) - 16,
                        child: CustomText(
                          text: 'people'.tr,
                          size: width * 0.05,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        width: (width * 0.6),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                              children: controller.people.entries.map(
                            (item) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Chip(
                                  elevation: 4,
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  deleteIconColor:
                                      Theme.of(context).colorScheme.primary,
                                  onDeleted: () => controller.peopleRemove(
                                      key: item.key.toString()),
                                  label: CustomText(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    text: item.key,
                                  ),
                                ),
                              );
                            },
                          ).toList()),
                        ),
                      ),
                      SizedBox(
                        width: (width * 0.13) - 16,
                        child: Center(
                          child: controller.isIos
                              ? CupertinoButton(
                                  padding: EdgeInsets.zero,
                                  child: FaIcon(
                                    FontAwesomeIcons.plus,
                                    size: width * 0.05,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () => controller.searchDialog(
                                        context: context,
                                        content: AlertDialog(
                                          content:
                                              GetBuilder<ExploreController>(
                                            init: Get.find<ExploreController>(),
                                            builder: (_) {
                                              return Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    autofocus: true,
                                                    onSubmitted: (val) =>
                                                        controller.loadingActor(
                                                            actor: val),
                                                  ),
                                                  if (controller.actorLoading ==
                                                      1) ...[
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12),
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                  if (controller.actorLoading ==
                                                          0 &&
                                                      controller.apiActor
                                                          .isNotEmpty) ...[
                                                    SingleChildScrollView(
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: List.generate(
                                                          controller
                                                              .names.length,
                                                          (index) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () => controller.peopleAdd(
                                                                  name: controller
                                                                          .names[
                                                                      index],
                                                                  id: controller
                                                                      .apiActor[
                                                                          controller
                                                                              .names[index]]![
                                                                          'id']
                                                                      .toString()),
                                                              child: ImageNetWork(
                                                                  link: imagebase +
                                                                      controller
                                                                          .apiActor[
                                                                              controller.names[index]]![
                                                                              'pic']
                                                                          .toString(),
                                                                  width: width *
                                                                      0.2,
                                                                  height:
                                                                      width *
                                                                          0.2),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ]
                                                ],
                                              );
                                            },
                                          ),
                                          title: CustomText(text: 'addname'.tr),
                                        ),
                                      ))
                              : IconButton(
                                  padding: EdgeInsets.zero,
                                  splashRadius: 15,
                                  onPressed: () => controller.searchDialog(
                                    context: context,
                                    content: AlertDialog(
                                      content: GetBuilder<ExploreController>(
                                        init: Get.find<ExploreController>(),
                                        builder: (_) {
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextField(
                                                autofocus: true,
                                                onSubmitted: (val) => controller
                                                    .loadingActor(actor: val),
                                              ),
                                              if (controller.actorLoading ==
                                                  1) ...[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 12),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                    ),
                                                  ),
                                                )
                                              ],
                                              if (controller.actorLoading ==
                                                      0 &&
                                                  controller
                                                      .apiActor.isNotEmpty) ...[
                                                SingleChildScrollView(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: List.generate(
                                                      controller.names.length,
                                                      (index) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: GestureDetector(
                                                          onTap: () => controller.peopleAdd(
                                                              name: controller
                                                                  .names[index],
                                                              id: controller
                                                                  .apiActor[
                                                                      controller
                                                                              .names[
                                                                          index]]![
                                                                      'id']
                                                                  .toString()),
                                                          child: ImageNetWork(
                                                              link: imagebase +
                                                                  controller
                                                                      .apiActor[
                                                                          controller
                                                                              .names[index]]![
                                                                          'pic']
                                                                      .toString(),
                                                              width:
                                                                  width * 0.2,
                                                              height:
                                                                  width * 0.2),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ]
                                            ],
                                          );
                                        },
                                      ),
                                      title: CustomText(text: 'addname'.tr),
                                    ),
                                  ),
                                  icon: FaIcon(
                                    FontAwesomeIcons.plus,
                                    size: width * 0.05,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'Year'.tr,
                        size: width * 0.05,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.58,
                            child: DropdownButton(
                                underline: Container(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: 2,
                                ),
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.primary,
                                value: controller.year,
                                isExpanded: true,
                                items: List.generate(
                                  controller.years.length,
                                  (index) => DropdownMenuItem(
                                    value: controller.years[index].toString(),
                                    child: CustomText(
                                      text: controller.years[index].toString(),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                onChanged: (value) => controller.yearChange(
                                    newYear: value ?? controller.year)),
                          ),
                          SizedBox(
                            width: width * 0.015,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: GestureDetector(
                              onTap: () =>
                                  controller.useSwitch(swaitch: 'year'),
                              child: FaIcon(
                                controller.useYear
                                    ? FontAwesomeIcons.circleCheck
                                    : FontAwesomeIcons.circleXmark,
                                size: width * 0.07,
                                color: controller.useYear
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'country'.tr,
                        size: width * 0.05,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: width * 0.58,
                            child: DropdownButton(
                              underline: Container(
                                color: Theme.of(context).colorScheme.primary,
                                height: 2,
                              ),
                              iconEnabledColor:
                                  Theme.of(context).colorScheme.primary,
                              value: controller.country,
                              isExpanded: true,
                              items: List.generate(
                                controller.countries.length,
                                (index) {
                                  return DropdownMenuItem(
                                    value: controller.countries[index][
                                        controller.userModel.language!
                                            .toLowerCase()],
                                    child: CustomText(
                                      isFit: true,
                                      text: controller.countries[index][
                                              controller.userModel.language!
                                                  .toLowerCase()]
                                          .toString(),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  );
                                },
                              ),
                              onChanged: (value) => controller.countryChanged(
                                country: value.toString(),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.015,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: GestureDetector(
                              onTap: () =>
                                  controller.useSwitch(swaitch: 'other'),
                              child: FaIcon(
                                controller.usecountry
                                    ? FontAwesomeIcons.circleCheck
                                    : FontAwesomeIcons.circleXmark,
                                size: width * 0.07,
                                color: controller.usecountry
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: (width * 0.22) - 16,
                        child: CustomText(
                          text: 'genre'.tr,
                          size: width * 0.05,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      SizedBox(
                        width: (width * 0.76) - 16,
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(
                              genresList.length,
                              (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 1),
                                child: ChoiceChip(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.secondary,
                                    elevation: controller.genres.contains(
                                            genresList[index]['id'].toString())
                                        ? 5
                                        : 0,
                                    selectedColor:
                                        Theme.of(context).colorScheme.primary,
                                    padding: EdgeInsets.zero,
                                    label: CustomText(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        text:
                                            genresList[index][controller.userModel.language.toString().toLowerCase()]
                                                .toString()),
                                    onSelected: (val) => controller.addGenres(
                                        genreId:
                                            genresList[index]['id'].toString()),
                                    selected: controller.genres
                                        .contains(genresList[index]['id'].toString())),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: 'type'.tr,
                        size: width * 0.05,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(
                        width: width * 0.72,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => controller.choiceChanged(
                                  flip: FilterChoice.movie),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.choice == FilterChoice.movie
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                width: width * 0.35,
                                child: Center(
                                  child: CustomText(
                                    color: controller.choice ==
                                            FilterChoice.movie
                                        ? Theme.of(context)
                                            .colorScheme
                                            .background
                                        : Theme.of(context).colorScheme.primary,
                                    text: 'movy'.tr,
                                    size: width * 0.06,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => controller.choiceChanged(
                                  flip: FilterChoice.tv),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: controller.choice == FilterChoice.tv
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                width: width * 0.34,
                                child: Center(
                                  child: CustomText(
                                    color: controller.choice == FilterChoice.tv
                                        ? Theme.of(context)
                                            .colorScheme
                                            .background
                                        : Theme.of(context).colorScheme.primary,
                                    text: 'shoe'.tr,
                                    size: width * 0.06,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: width,
                  child: controller.isIos
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: CupertinoButton(
                            color: Theme.of(context).colorScheme.primary,
                            child: CustomText(
                              weight: FontWeight.bold,
                              text: 'explore'.tr,
                              size: width * 0.05,
                              color: Theme.of(context).colorScheme.background,
                            ),
                            onPressed: () => controller.apiCall(),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () => controller.apiCall(),
                          child: CustomText(
                            weight: FontWeight.bold,
                            text: 'explore'.tr,
                            size: width * 0.05,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
