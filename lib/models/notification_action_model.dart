import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/enums.dart';

class NotificationAction {
  final NotificationType type;
  final String userId;
  final String movieId;
  final String movieOverView;
  final String posterPath;
  final String title;
  final String notificationBody;
  final String userName;
  final String userImage;
  final bool isShow;
  final DateTime? time;
  bool? open;

  NotificationAction(
      {required this.movieOverView,
      this.open,
      required this.type,
      required this.userImage,
      required this.notificationBody,
      required this.posterPath,
      required this.userName,
      required this.title,
      required this.isShow,
      required this.userId,
      this.time,
      required this.movieId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.toString(),
      'userId': userId,
      'movieId': movieId,
      'movieOverView': movieOverView,
      'posterPath': posterPath,
      'title': title,
      'isShow': isShow,
      'open': false,
      'notificationBody': notificationBody,
      'userImage': userImage,
      'userName': userName,
      'time': DateTime.now().toString()
    };
  }

  factory NotificationAction.fromMap(Map<String, dynamic> map) {
    DateTime conversion = map['time'].runtimeType == String
        ? DateTime.parse(map['time'] as String)
        : map['time'].runtimeType == Timestamp
            ? map['time'].toDate()
            : Timestamp(map['time']['_seconds'], map['time']['_nanoseconds'])
                .toDate();
    return NotificationAction(
        movieOverView: map['movieOverView'] as String,
        type: NotificationType.values
            .firstWhere((e) => e.toString() == map['type']),
        userId: map['userId'] as String,
        movieId: map['movieId'].toString(),
        posterPath: map['posterPath'] as String,
        title: map['title'] as String,
        isShow: map['isShow'].runtimeType == String
            ? bool.parse(map['isShow'])
            : map['isShow'] as bool,
        open: map['open'].runtimeType == String
            ? bool.parse(map['open'])
            : map['open'] as bool,
        notificationBody: map['notificationBody'] as String,
        userImage: map['userImage'] as String,
        userName: map['userName'] as String,
        time: conversion);
  }
}
