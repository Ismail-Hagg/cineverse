import 'package:cineverse/controllers/auth_controller.dart';
import 'package:cineverse/controllers/home_controller.dart';
import 'package:cineverse/controllers/search_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:cineverse/widgets/login_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPhone extends StatelessWidget {
  const SearchPhone({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isIos = Get.find<AuthController>().platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: Get.find<SearchMoreController>().info.isSearch == false
          ? AppBar(
              iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.primary,
              ),
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.background,
              centerTitle: true,
              title: CustomText(
                color: Theme.of(context).colorScheme.primary,
                text: Get.find<SearchMoreController>().info.title.toString(),
              ),
            )
          : null,
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        return GetBuilder<SearchMoreController>(
          init: Get.find<SearchMoreController>(),
          builder: (controller) => Column(
            children: [
              if (controller.info.isSearch == true) ...[
                SafeArea(
                  bottom: false,
                  child: SizedBox(
                    width: width,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        child: LoginInput(
                          controller: controller.controller,
                          sub: (val) {
                            controller.search(
                                loadMore: false,
                                query: val.trim(),
                                page: 1,
                                search: true);
                          },
                          focusNode: controller.focusNode,
                          leadingButton: GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                                isIos ? CupertinoIcons.back : Icons.arrow_back),
                          ),
                          suffex: GestureDetector(
                            onTap: () => controller.searchClear(),
                            child: Icon(
                                isIos ? CupertinoIcons.clear : Icons.clear),
                          ),
                          suffexColor: Theme.of(context).colorScheme.primary,
                          isSearch: true,
                          textSize: 15,
                          height: width * 0.115,
                          width: width * 0.9,
                          obscure: false,
                          autoFocus: true,
                          isSelected: controller.detect == false
                              ? true
                              : controller.focus,
                          hintNoLable: 'search'.tr,
                        ),
                      ),
                    ),
                  ),
                )
              ],
              Expanded(
                child: controller.loading
                    ? Center(
                        child: isIos
                            ? CupertinoActivityIndicator(
                                radius: width * 0.06,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.primary),
                      )
                    : controller.model.isError == true
                        ? Center(
                            child: CustomText(
                              text: controller.model.errorMessage.toString(),
                            ),
                          )
                        : controller.model.totalResults == 0 ||
                                controller.model.results!.isEmpty
                            ? Center(
                                child: CustomText(text: 'res'.tr),
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
                                        onTap: () => Get.find<HomeController>()
                                            .navToDetale(
                                                res: controller
                                                    .model.results![index]),
                                        child: controller.model.results![index]
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
                              ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
