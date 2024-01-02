import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class EpisodeKeeping extends StatelessWidget {
  final double width;
  final String link;
  final String title;
  final String nextDate;
  final bool isEnglish;
  final bool even;
  final int episode;
  final int season;
  final Function() homeNav;
  const EpisodeKeeping({
    super.key,
    required this.width,
    required this.link,
    required this.title,
    required this.nextDate,
    required this.isEnglish,
    required this.homeNav,
    required this.even,
    required this.episode,
    required this.season,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * 0.235,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 4,
            spreadRadius: 0.1,
          )
        ],
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Row(
        children: [
          SizedBox(
            width: width * 0.25,
            height: width * 0.25,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: GestureDetector(
                onTap: homeNav,
                child: ImageNetWork(
                  link: link,
                  width: width * 0.23,
                  height: width * 0.23,
                  border: Theme.of(context).colorScheme.primary,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: SizedBox(
              width: (width * 0.75) - 28,
              height: width * 0.235,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width,
                    height: (width * 0.23) * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: CustomText(
                        isFit: true,
                        aligning: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        maxline: 1,
                        flow: TextOverflow.ellipsis,
                        text: title,
                        size: width * 0.05,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.5),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: even
                                ? Get.isDarkMode
                                    ? Colors.green.withOpacity(0.7)
                                    : Colors.green
                                : Get.isDarkMode
                                    ? Colors.red.withOpacity(0.7)
                                    : Colors.red,
                          ),
                          child: CustomText(
                            text:
                                '${'epnum'.tr}: $episode  -  ${'sason'.tr}: $season',
                            size: width * 0.04,
                            flow: TextOverflow.ellipsis,
                            color: whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: nextDate.trim() != ''
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    children: [
                      if (nextDate.trim() != '') ...[
                        SizedBox(
                          width: ((width * 0.75) - 28) * 0.85,
                          height: (width * 0.23) * 0.28,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: CustomText(
                              isFit: true,
                              aligning: isEnglish
                                  ? Alignment.bottomLeft
                                  : Alignment.bottomRight,
                              text: '${'nextepisodedate'.tr} : $nextDate',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(
                        height: (width * 0.23) * 0.28,
                        width: ((width * 0.75) - 28) * 0.15,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FittedBox(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: homeNav,
                              child: FaIcon(
                                FontAwesomeIcons.house,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
