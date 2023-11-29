import 'package:cineverse/utils/functions.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CommentWidget extends StatelessWidget {
  final int elevation;
  final bool imageBorder;
  final String imageLink;
  final double width;
  final bool isMe;
  final String timeAgo;
  final String comment;
  final String userName;
  final bool isIos;
  final bool commentOpen;
  final bool isLiked;
  final bool isDisLiked;
  final bool hasMore;
  final int likes;
  final int dislikes;
  final int? replyNum;
  final Function() profileNav;
  final Function() delete;
  final Function() replies;
  final Function() like;
  final Function() dislike;
  final Function() commentToggle;

  const CommentWidget(
      {super.key,
      required this.elevation,
      required this.imageBorder,
      required this.imageLink,
      required this.width,
      required this.isMe,
      required this.timeAgo,
      required this.comment,
      required this.userName,
      required this.isIos,
      required this.commentOpen,
      required this.like,
      required this.dislike,
      required this.commentToggle,
      required this.delete,
      required this.replies,
      required this.isLiked,
      required this.isDisLiked,
      required this.hasMore,
      required this.likes,
      required this.dislikes,
      required this.profileNav,
      this.replyNum});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: profileNav,
                        child: ImageNetWork(
                          border:
                              imageBorder == false ? Colors.transparent : null,
                          link: imageLink,
                          width: width * 0.12,
                          height: width * 0.12,
                          circle: true,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: width * 0.12,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: width * 0.625,
                              child: GestureDetector(
                                onTap: profileNav,
                                child: CustomText(
                                  maxline: 1,
                                  flow: TextOverflow.ellipsis,
                                  text: userName,
                                  size: 16,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            CustomText(
                              text: timeAgo,
                              size: 12,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                if (isMe) ...[
                  isIos
                      ? CupertinoButton(
                          child: FaIcon(
                            FontAwesomeIcons.trash,
                            color: Theme.of(context).colorScheme.primary,
                            size: (width * 0.12) * 0.35,
                          ),
                          onPressed: () {},
                        )
                      : IconButton(
                          onPressed: () {},
                          icon: FaIcon(
                            FontAwesomeIcons.trash,
                            color: Theme.of(context).colorScheme.primary,
                            size: (width * 0.12) * 0.35,
                          ),
                          splashRadius: 15,
                        ),
                ]
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomText(
                maxline: maxLines(text: comment, width: width - 16, maxLines: 4)
                    ? commentOpen
                        ? null
                        : 4
                    : null,
                text: comment,
                flow: maxLines(text: comment, width: width - 16, maxLines: 4)
                    ? commentOpen
                        ? null
                        : TextOverflow.ellipsis
                    : null,
                size: 16,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: GestureDetector(
                            onTap: like,
                            child: Icon(Icons.thumb_up,
                                color: isLiked
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        CustomText(text: likes.toString())
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8),
                          child: GestureDetector(
                            onTap: dislike,
                            child: Icon(
                              Icons.thumb_down,
                              color: isDisLiked
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        CustomText(text: dislikes.toString())
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    if (hasMore) ...[
                      isIos
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CupertinoButton(
                                child: CustomText(
                                  text: '$replyNum ${'replies'.tr}',
                                  color: Theme.of(context).colorScheme.primary,
                                  size: (width * 0.12) * 0.35,
                                ),
                                onPressed: () {},
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {},
                                child: CustomText(
                                  text: '$replyNum ${'replies'.tr}',
                                  color: Theme.of(context).colorScheme.primary,
                                  size: (width * 0.12) * 0.35,
                                ),
                              ),
                            ),
                    ],
                    isIos
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CupertinoButton(
                              child: FaIcon(
                                FontAwesomeIcons.reply,
                                color: Theme.of(context).colorScheme.primary,
                                size: (width * 0.12) * 0.35,
                              ),
                              onPressed: () {},
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              onPressed: () {},
                              icon: FaIcon(
                                FontAwesomeIcons.reply,
                                color: Theme.of(context).colorScheme.primary,
                                size: (width * 0.12) * 0.35,
                              ),
                            ),
                          ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
