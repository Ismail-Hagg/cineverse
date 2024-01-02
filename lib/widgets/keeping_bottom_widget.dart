import 'package:cineverse/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class KeepingBottom extends StatelessWidget {
  final int episode;
  final int season;
  final int myEpisode;
  final int mySeason;
  final int nextEpisode;
  final int nextSeason;
  final String nextDate;
  final String statut;
  final bool isIos;
  final double width;
  final Function() epAdd;
  final Function() epMin;
  final Function() seAdd;
  final Function() seMin;
  final Function() edit;
  const KeepingBottom(
      {super.key,
      required this.isIos,
      required this.width,
      required this.episode,
      required this.season,
      required this.myEpisode,
      required this.mySeason,
      required this.nextEpisode,
      required this.nextSeason,
      required this.nextDate,
      required this.statut,
      required this.epAdd,
      required this.epMin,
      required this.seAdd,
      required this.seMin,
      required this.edit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'epnum'.tr,
                color: Theme.of(context).colorScheme.primary,
                size: width * 0.05,
              ),
              Row(
                children: [
                  SizedBox(
                    height: width * 0.09,
                    width: width * 0.09,
                    child: isIos
                        ? CupertinoButton(
                            borderRadius:
                                BorderRadius.all(Radius.circular(width * 0.1)),
                            padding: EdgeInsets.zero,
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: epAdd,
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Theme.of(context).colorScheme.background,
                              size: width * 0.05,
                            ),
                          )
                        : MaterialButton(
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: epAdd,
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Theme.of(context).colorScheme.background,
                              size: width * 0.05,
                            ),
                          ),
                  ),
                  SizedBox(
                    width: width * 0.22,
                    child: CustomText(
                      align: TextAlign.center,
                      text: myEpisode.toString(),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    height: width * 0.09,
                    width: width * 0.09,
                    child: isIos
                        ? CupertinoButton(
                            borderRadius:
                                BorderRadius.all(Radius.circular(width * 0.1)),
                            padding: EdgeInsets.zero,
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: epMin,
                            child: FaIcon(
                              FontAwesomeIcons.minus,
                              color: Theme.of(context).colorScheme.background,
                              size: width * 0.05,
                            ),
                          )
                        : MaterialButton(
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: epMin,
                            child: FaIcon(
                              FontAwesomeIcons.minus,
                              color: Theme.of(context).colorScheme.background,
                              size: width * 0.05,
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: width * 0.07,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: 'sason'.tr,
                color: Theme.of(context).colorScheme.primary,
                size: width * 0.05,
              ),
              Row(
                children: [
                  SizedBox(
                    height: width * 0.09,
                    width: width * 0.09,
                    child: isIos
                        ? CupertinoButton(
                            borderRadius:
                                BorderRadius.all(Radius.circular(width * 0.1)),
                            padding: EdgeInsets.zero,
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: seAdd,
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Theme.of(context).colorScheme.background,
                              size: width * 0.05,
                            ),
                          )
                        : MaterialButton(
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: seAdd,
                            child: FaIcon(
                              FontAwesomeIcons.plus,
                              color: Theme.of(context).colorScheme.background,
                              size: width * 0.05,
                            ),
                          ),
                  ),
                  SizedBox(
                    width: width * 0.22,
                    child: CustomText(
                      align: TextAlign.center,
                      text: mySeason.toString(),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(
                    height: width * 0.09,
                    width: width * 0.09,
                    child: isIos
                        ? CupertinoButton(
                            borderRadius:
                                BorderRadius.all(Radius.circular(width * 0.1)),
                            padding: EdgeInsets.zero,
                            onPressed: seMin,
                            color: Theme.of(context).colorScheme.primary,
                            child: FaIcon(
                              FontAwesomeIcons.minus,
                              color: Theme.of(context).colorScheme.background,
                              size: width * 0.05,
                            ),
                          )
                        : MaterialButton(
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: seMin,
                            child: FaIcon(
                              FontAwesomeIcons.minus,
                              color: Theme.of(context).colorScheme.background,
                              size: width * 0.05,
                            ),
                          ),
                  )
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (width * 0.5) - 12,
                height: width * 0.1,
                child: CustomText(
                  align: TextAlign.start,
                  text: 'lastepisode'.tr,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(
                width: (width * 0.5) - 12,
                height: width * 0.1,
                child: CustomText(
                  align: TextAlign.start,
                  text: '${'epnum'.tr} $episode-${'sason'.tr} $season',
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          if (statut != 'Ended') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (width * 0.5) - 12,
                  height: width * 0.1,
                  child: CustomText(
                    align: TextAlign.start,
                    text: 'nextepisode'.tr,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(
                  width: (width * 0.5) - 12,
                  height: width * 0.1,
                  child: CustomText(
                    align: TextAlign.start,
                    text: nextEpisode == 0
                        ? 'unknow'.tr
                        : '${'epnum'.tr} $nextEpisode-${'sason'.tr} $nextSeason',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            )
          ],
          if (statut != 'Ended') ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: (width * 0.5) - 12,
                  height: width * 0.1,
                  child: CustomText(
                    align: TextAlign.start,
                    text: 'nextepisodedate'.tr,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(
                  width: (width * 0.5) - 12,
                  height: width * 0.1,
                  child: CustomText(
                    align: TextAlign.start,
                    text: nextDate == '' ? 'unknow'.tr : nextDate,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            )
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: (width * 0.5) - 12,
                height: width * 0.1,
                child: CustomText(
                  align: TextAlign.start,
                  text: 'status'.tr,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(
                width: (width * 0.5) - 12,
                height: width * 0.1,
                child: CustomText(
                  align: TextAlign.start,
                  text: statut == 'Ended' ? 'ended'.tr : 'return'.tr,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: width,
              child: isIos
                  ? CupertinoButton(
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: edit,
                      child: CustomText(
                          text: 'edit'.tr,
                          color: Theme.of(context).colorScheme.background),
                    )
                  : ElevatedButton(
                      onPressed: edit,
                      child: CustomText(
                          text: 'edit'.tr,
                          color: Theme.of(context).colorScheme.background),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
