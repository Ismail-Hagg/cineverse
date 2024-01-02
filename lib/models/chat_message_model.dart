// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessageModel {
  String userId;
  String otherId;
  bool isPicOnline;
  Timestamp change;
  List<dynamic> messages;
  String onlinePath;
  String userNsme;
  DocumentReference ref;
  bool isUpdated;
  String token;
  ChatMessageModel({
    required this.userId,
    required this.otherId,
    required this.isPicOnline,
    required this.change,
    required this.messages,
    required this.onlinePath,
    required this.userNsme,
    required this.ref,
    required this.isUpdated,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': otherId,
      'isPicOnline': isPicOnline,
      'change': change,
      'messages': messages,
      'onlinePath': onlinePath,
      'userNsme': userNsme,
      'ref': ref,
      'isUpdated': isUpdated,
      'token': token,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      userId: map['userId'] as String,
      otherId: map['otherId'] ?? '',
      isPicOnline: map['isPicOnline'] as bool,
      change: map['change'],
      messages: map['messages'],
      onlinePath: map['onlinePath'] as String,
      userNsme: map['userNsme'] as String,
      ref: map['ref'],
      isUpdated: map['isUpdated'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
