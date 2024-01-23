import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String commentId;
  String userId;
  String userName;
  String userLink;
  DateTime time;
  String comment;
  int likes;
  int dislikea;
  bool hasMore;
  String token;
  bool commentOpen;
  int repliesNum;
  String movieId;
  bool? showRep;
  bool? replyBox;
  List<CommentModel>? subComments;
  CommentModel(
      {required this.commentId,
      required this.userId,
      this.subComments,
      required this.userName,
      required this.userLink,
      this.showRep,
      required this.time,
      required this.comment,
      required this.likes,
      required this.dislikea,
      required this.hasMore,
      required this.token,
      required this.commentOpen,
      required this.repliesNum,
      required this.movieId,
      this.replyBox});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'userLink': userLink,
      'time': Timestamp.now(),
      'comment': comment,
      'likes': likes,
      'dislikea': dislikea,
      'hasMore': hasMore,
      'token': token,
      'commentOpen': commentOpen,
      'repliesNum': repliesNum,
      'movieId': movieId,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
        commentId: map['commentId'] as String,
        userId: map['userId'] as String,
        userName: map['userName'] as String,
        userLink: map['userLink'] as String,
        time: map['time'].toDate(),
        comment: map['comment'] as String,
        likes: map['likes'] as int,
        dislikea: map['dislikea'] as int,
        hasMore: map['hasMore'] as bool,
        token: map['token'] as String,
        commentOpen: false,
        repliesNum: map['repliesNum'] as int,
        movieId: map['movieId'] as String,
        replyBox: false,
        showRep: false);
  }
}
