import 'package:cineverse/controllers/comments_page_controller.dart';
import 'package:cineverse/widgets/comment_widget.dart';
import 'package:cineverse/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              : Column(
                  children: List.generate(
                    controller.commentList.length,
                    (index) {
                      return CommentWidget(
                        sendRep: () {},
                        // () => controller.reply(index: index),
                        paper:
                            // controller.replyToComment.trim() == ''
                            //     ? Theme.of(context).colorScheme.secondary
                            //     :
                            Theme.of(context).colorScheme.primary,
                        repChange: (rep) {},
                        // => controller.replyChange(reply: rep),
                        repBox: controller.commentList[index].replyBox as bool,
                        flipRep: () {},
                        //=> controller.repFlip(index: index),
                        showRep: controller.commentList[index].showRep as bool,
                        likes: controller.commentList[index].likes,
                        dislikes: controller.commentList[index].dislikea,
                        profileNav: () {},
                        // => controller.navToProfile(
                        //     index: index, reply: false, repIndex: 0),
                        hasMore: controller.commentList[index].hasMore,
                        like: () {},
                        // => controller.likeController(
                        //     reply: false,
                        //     repIndex: 0,
                        //     like: true,
                        //     index: index),
                        dislike: () {},
                        // => controller.likeController(
                        //     reply: false,
                        //     repIndex: 0,
                        //     like: false,
                        //     index: index),
                        commentToggle: () {},
                        //  => controller.commentFull(
                        //     index: index, reply: false, repIndex: 0),
                        delete: () {},
                        //  => controller.commentDelete(
                        //     reply: false,
                        //     repIndex: 0,
                        //     index: index,
                        //     context: context,
                        //     isIos: isIos),
                        replies: () {},
                        // => controller.repBoxOpen(
                        //   index: index,
                        // ),
                        isLiked: controller.userModel.commentLike!
                            .contains(controller.commentList[index].commentId),
                        isDisLiked: controller.userModel.commentDislike!
                            .contains(controller.commentList[index].commentId),
                        commentOpen: controller.commentList[index].commentOpen,
                        isIos: controller.isIos,
                        elevation: 5,
                        imageBorder: false,
                        imageLink: controller.commentList[index].userLink,
                        width: width,
                        isMe: controller.commentList[index].userId ==
                            controller.userModel.userId.toString(),
                        timeAgo: 'time',
                        // timeAgo(controller.commentList[index].time),
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
                                      repBox: controller
                                          .commentList[index].replyBox as bool,
                                      flipRep: () {},
                                      // =>
                                      //     controller.repFlip(index: index),
                                      showRep: controller
                                          .commentList[index].showRep as bool,
                                      subComments: true,
                                      likes: controller.commentList[index]
                                          .subComments![comIndex].likes,
                                      dislikes: controller.commentList[index]
                                          .subComments![comIndex].dislikea,
                                      profileNav: () {},
                                      // => controller.navToProfile(
                                      //     reply: true,
                                      //     repIndex: comIndex,
                                      //     index: index),
                                      hasMore: false,
                                      like: () {},
                                      // => controller.likeController(
                                      //     reply: true,
                                      //     repIndex: comIndex,
                                      //     like: true,
                                      //     index: index),
                                      dislike: () {},
                                      //  => controller.likeController(
                                      //     reply: true,
                                      //     repIndex: comIndex,
                                      //     like: false,
                                      //     index: index),
                                      commentToggle: () {},
                                      // =>
                                      //     controller.commentFull(
                                      //         repIndex: comIndex,
                                      //         reply: true,
                                      //         index: index),
                                      delete: () {},
                                      //  => controller.commentDelete(
                                      //     reply: true,
                                      //     repIndex: comIndex,
                                      //     index: index,
                                      //     context: context,
                                      //     isIos: isIos),
                                      replies: () {},
                                      isLiked: controller.userModel.commentLike!
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
                                      commentOpen: controller.commentList[index]
                                          .subComments![comIndex].commentOpen,
                                      isIos: controller.isIos,
                                      elevation: 5,
                                      imageBorder: false,
                                      imageLink: controller.commentList[index]
                                          .subComments![comIndex].userLink,
                                      width: width,
                                      isMe: controller.commentList[index]
                                              .subComments![comIndex].userId ==
                                          controller.userModel.userId
                                              .toString(),
                                      timeAgo: 'time',
                                      // timeAgo(controller
                                      //     .commentList[index]
                                      //     .subComments![comIndex]
                                      //     .time),
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
                );
        }),
      ),
    );
  }
}
