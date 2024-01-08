import 'package:cineverse/controllers/comments_page_controller.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cineverse/utils/enums.dart';
import 'package:cineverse/utils/functions.dart';
import 'package:cineverse/widgets/comment_widget.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:cineverse/widgets/image_network.dart';
import 'package:cineverse/widgets/menu_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CommentsPagePhone extends StatelessWidget {
  const CommentsPagePhone({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentsPageController>(
      init: Get.find<CommentsPageController>(),
      builder: (controller) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          title: CustomText(
            text: controller.model.fromProfile
                ? controller.model.isMe
                    ? 'mycom'.tr
                    : '${'comby'.tr} ${controller.model.user.userName}'
                : controller.model.user.userName.toString(),
            color: Theme.of(context).colorScheme.primary,
          ),
          actions: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: controller.isIos ? 0 : 12.0),
              child: Center(
                child: Menu(
                  ios: controller.isIos,
                  titles: [
                    'timerecent'.tr,
                    'timeold'.tr,
                    'mostlikes'.tr,
                    'leastlikes'.tr,
                    'mostrep'.tr
                  ],
                  funcs: [
                    () => controller.sorting(order: CommentOrder.timeRecent),
                    () => controller.sorting(order: CommentOrder.timeOld),
                    () => controller.sorting(order: CommentOrder.mostLikes),
                    () => controller.sorting(order: CommentOrder.leastLikes),
                    () => controller.sorting(order: CommentOrder.replies)
                  ],
                  child: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                ),
              ),
            )
          ],
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double width = constraints.maxWidth;
          return controller.loading
              ? Center(
                  child: SizedBox(
                    height: width * 0.14,
                    width: width * 0.14,
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
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      controller.commentList.length,
                      (index) {
                        return CommentWidget(
                          shifty: Row(
                            children: [
                              if (controller.choices[index].$1.isError ==
                                  false) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () => controller.movieNav(
                                        index: index,
                                        movie: controller.choices[index].$1),
                                    child: ImageNetWork(
                                        circle: true,
                                        border: Colors.transparent,
                                        link: imagebase +
                                            controller
                                                .choices[index].$1.posterPath
                                                .toString(),
                                        width: 50,
                                        height: 50),
                                  ),
                                ),
                              ],
                              if (controller.choices[index].$2.isError ==
                                  false) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: GestureDetector(
                                    onTap: () => controller.movieNav(
                                        index: index,
                                        movie: controller.choices[index].$2),
                                    child: ImageNetWork(
                                        circle: true,
                                        border: Colors.transparent,
                                        link: imagebase +
                                            controller
                                                .choices[index].$2.posterPath
                                                .toString(),
                                        width: 50,
                                        height: 50),
                                  ),
                                )
                              ]
                            ],
                          ),
                          shift: true,
                          sendRep: () => controller.reply(index: index),
                          paper: controller.replyToComment.trim() == ''
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          repChange: (rep) =>
                              controller.replyChange(reply: rep),
                          repBox:
                              controller.commentList[index].replyBox as bool,
                          flipRep: () => controller.repFlip(index: index),
                          showRep:
                              controller.commentList[index].showRep as bool,
                          likes: controller.commentList[index].likes,
                          dislikes: controller.commentList[index].dislikea,
                          profileNav: () {},
                          hasMore: controller.commentList[index].hasMore,
                          like: () {},
                          dislike: () {},
                          commentToggle: () => controller.commentFull(
                              index: index, reply: false, repIndex: 0),
                          delete: () {},
                          replies: () => controller.repBoxOpen(
                            index: index,
                          ),
                          isLiked: controller.userModel.commentLike!.contains(
                              controller.commentList[index].commentId),
                          isDisLiked: controller.userModel.commentDislike!
                              .contains(
                                  controller.commentList[index].commentId),
                          commentOpen:
                              controller.commentList[index].commentOpen,
                          isIos: controller.isIos,
                          elevation: 5,
                          imageBorder: false,
                          imageLink: controller.commentList[index].userLink,
                          width: width,
                          isMe: controller.commentList[index].userId ==
                              controller.userModel.userId.toString(),
                          timeAgo: timeAgo(controller.commentList[index].time),
                          comment: controller.commentList[index].comment,
                          userName: controller.commentList[index].userName,
                          replyNum: controller.commentList[index].repliesNum,
                          subs: controller.commentList[index].subComments ==
                                      null ||
                                  controller.commentList[index].showRep == false
                              ? null
                              : Column(
                                  children: List.generate(
                                    controller
                                        .commentList[index].subComments!.length,
                                    (comIndex) {
                                      return CommentWidget(
                                        shift: true,
                                        repBox: controller.commentList[index]
                                            .replyBox as bool,
                                        flipRep: () {},
                                        showRep: controller
                                            .commentList[index].showRep as bool,
                                        subComments: true,
                                        likes: controller.commentList[index]
                                            .subComments![comIndex].likes,
                                        dislikes: controller.commentList[index]
                                            .subComments![comIndex].dislikea,
                                        profileNav: () => controller.profileNav(
                                            index: index, repIndex: comIndex),
                                        hasMore: false,
                                        like: () {},
                                        dislike: () {},
                                        commentToggle: () {},
                                        delete: () {},
                                        replies: () {},
                                        isLiked: controller
                                            .userModel.commentLike!
                                            .contains(controller
                                                .commentList[index]
                                                .subComments![comIndex]
                                                .commentId),
                                        isDisLiked: controller
                                            .userModel.commentDislike!
                                            .contains(controller
                                                .commentList[index]
                                                .subComments![comIndex]
                                                .commentId),
                                        commentOpen: controller
                                            .commentList[index]
                                            .subComments![comIndex]
                                            .commentOpen,
                                        isIos: controller.isIos,
                                        elevation: 5,
                                        imageBorder: false,
                                        imageLink: controller.commentList[index]
                                            .subComments![comIndex].userLink,
                                        width: width,
                                        isMe: controller
                                                .commentList[index]
                                                .subComments![comIndex]
                                                .userId ==
                                            controller.userModel.userId
                                                .toString(),
                                        timeAgo: timeAgo(controller
                                            .commentList[index]
                                            .subComments![comIndex]
                                            .time),
                                        comment: controller.commentList[index]
                                            .subComments![comIndex].comment,
                                        userName: controller.commentList[index]
                                            .subComments![comIndex].userName,
                                        replyNum: controller.commentList[index]
                                            .subComments![comIndex].repliesNum,
                                      );
                                    },
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
