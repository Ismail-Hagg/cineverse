// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cineverse/models/result_details_model.dart';

class ActorModel {
  bool? isError;
  String? errorMessage;
  String? link;
  String? name;
  String? birth;
  List<String>? roles;
  String? bio;
  List<ResultsDetail>? acted;
  List<ResultsDetail>? directed;
  List<ResultsDetail>? produced;
  int? id;
  ActorModel({
    this.link,
    this.name,
    this.errorMessage,
    this.isError,
    this.birth,
    this.id,
    this.roles,
    this.bio,
    this.acted,
    this.directed,
    this.produced,
  });

  factory ActorModel.fromMap(Map<String, dynamic> map) {
    return ActorModel(
        id: map['id'] ?? 0,
        link: map['profile_path'] ?? '',
        name: map['name'] ?? '',
        birth: map['birthday'] ?? '',
        bio: map['biography'] ?? '',
        isError: false,
        errorMessage: '');
  }
}
