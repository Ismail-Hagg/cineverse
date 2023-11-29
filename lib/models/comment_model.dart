import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  CommentModel({
    required this.commentId,
    required this.userId,
    required this.userName,
    required this.userLink,
    required this.time,
    required this.comment,
    required this.likes,
    required this.dislikea,
    required this.hasMore,
    required this.token,
    required this.commentOpen,
    required this.repliesNum,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'userLink': userLink,
      'time': time.millisecondsSinceEpoch,
      'comment': comment,
      'likes': likes,
      'dislikea': dislikea,
      'hasMore': hasMore,
      'token': token,
      'commentOpen': commentOpen,
      'repliesNum': repliesNum,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['commentId'] as String,
      userId: map['userId'] as String,
      userName: map['userName'] as String,
      userLink: map['userLink'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      comment: map['comment'] as String,
      likes: map['likes'] as int,
      dislikea: map['dislikea'] as int,
      hasMore: map['hasMore'] as bool,
      token: map['token'] as String,
      commentOpen: map['commentOpen'] as bool,
      repliesNum: map['repliesNum'] as int,
    );
  }
}
