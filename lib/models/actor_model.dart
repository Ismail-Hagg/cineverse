// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cineverse/models/result_details_model.dart';

class ActorModel {
  bool? isError;
  String? imdbId;
  String? errorMessage;
  String? link;
  String? name;
  String? birth;
  String? bio;
  int? id;
  ActorDetale? detales;
  ActorModel({
    this.link,
    this.detales,
    this.name,
    this.errorMessage,
    this.isError,
    this.imdbId,
    this.birth,
    this.id,
    this.bio,
  });

  factory ActorModel.fromMap(Map<String, dynamic> map) {
    return ActorModel(
        detales: ActorDetale(isError: true),
        id: map['id'] ?? 0,
        imdbId: map['imdb_id'] ?? '',
        link: map['profile_path'] ?? '',
        name: map['name'] ?? '',
        birth: map['birthday'] ?? '',
        bio: map['biography'] ?? '',
        isError: false,
        errorMessage: '');
  }
}

class ActorDetale {
  bool? isError;
  String? errorMessage;
  List<ResultsDetail>? actedMovies;
  List<ResultsDetail>? actedShows;
  List<ResultsDetail>? directed;
  List<ResultsDetail>? produced;
  ActorDetale({
    this.isError,
    this.errorMessage,
    this.actedMovies,
    this.actedShows,
    this.directed,
    this.produced,
  });

  factory ActorDetale.fromMap(Map<String, dynamic> map) {
    List<ResultsDetail>? actedMovies = [];
    List<ResultsDetail>? actedShows = [];
    List<ResultsDetail>? directed = [];
    List<ResultsDetail>? produced = [];
    if (map['cast'] != null || map['cast'] != []) {
      map['cast'].forEach(
        (item) {
          if (item['genre_ids'] != null && !item['genre_ids'].contains(10767)) {
            item['media_type'] == 'movie'
                ? actedMovies.add(ResultsDetail.fromMap(item))
                : actedShows.add(ResultsDetail.fromMap(item));
          }
        },
      );
    }

    if (map['crew'] != null || map['crew'] != []) {
      map['crew'].forEach(
        (item) {
          if (item['genre_ids'] != null && !item['genre_ids'].contains(10767)) {
            item['job'] == 'Director'
                ? directed.add(ResultsDetail.fromMap(item))
                : item['job'] == 'Producer'
                    ? produced.add(ResultsDetail.fromMap(item))
                    : null;
          }
        },
      );
    }

    return ActorDetale(
      isError: false,
      errorMessage: '',
      actedMovies: actedMovies,
      actedShows: actedShows,
      directed: directed,
      produced: produced,
    );
  }
}
