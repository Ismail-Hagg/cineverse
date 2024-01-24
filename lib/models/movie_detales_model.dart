import 'package:cineverse/models/cast_model.dart';
import 'package:cineverse/models/collection_model.dart';
import 'package:cineverse/models/result_model.dart';
import 'package:cineverse/models/season_model.dart';
import 'package:cineverse/models/trailer_model.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieDetaleModel {
  List<String>? genres;
  int? id;
  String? imdbId;
  String? overview;
  String? posterPath;
  String? releaseDate;
  int? runtime;
  String? status;
  String? title;
  double? voteAverage;
  bool? isShow;
  String? originCountry;
  CastModel? cast;
  TrailerModel? trailer;
  ResultModel? recomendation;
  bool? isError;
  String? errorMessage;
  Timestamp? timestamp;
  SeasonModel? seaosn;
  String? collectionId;
  CollectionModel? collection;

  MovieDetaleModel(
      {this.genres,
      this.id,
      this.imdbId,
      this.overview,
      this.collectionId,
      this.posterPath,
      this.releaseDate,
      this.runtime,
      this.status,
      this.timestamp,
      this.title,
      this.voteAverage,
      this.collection,
      this.isShow,
      this.originCountry,
      this.cast,
      this.trailer,
      this.seaosn,
      this.recomendation,
      this.isError,
      this.errorMessage});

  MovieDetaleModel.fromMap(Map<String, dynamic> json, {bool? fire}) {
    double voteAve = json['vote_average'] ?? 0.0;
    String relDate =
        json['release_date'] ?? json['first_air_date'] ?? 'unknown';
    int run = json['runtime'] ?? json['seasons'][0]['season_number'];

    if (json['genres'] != null) {
      genres = <String>[];
      json['genres'].forEach(
        (v) {
          genres!.add(fire == true ? v : v['name']);
        },
      );
    }
    collectionId = json['belongs_to_collection'] != null
        ? json['belongs_to_collection']['id'].toString()
        : '';
    id = json['id'];
    imdbId = json['imdb_id'] ?? '';
    overview = json['overview'];
    posterPath = json['poster_path'];

    releaseDate = relDate != 'unknown' && relDate != ''
        ? relDate.substring(0, 4)
        : relDate;
    status = json['status'];
    runtime = json['first_air_date'] == null
        ? run
        : run == 0
            ? json['seasons'].length - 1
            : json['seasons'].length;

    title = json['title'] ?? json['name'];
    voteAverage = double.parse(voteAve.toStringAsFixed(1));
    isShow = json['isShow'] ?? json['first_air_date'] != null;
    originCountry = json['origin_country'] == null
        ? json['production_countries'].length == 0
            ? ''
            : json['production_countries'][0]['name']
        : countries[json['origin_country'][0]];
    isError = false;
    errorMessage = '';
    timestamp = json['timestamp'] ?? Timestamp.now();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'genres': genres,
      'imdb_id': imdbId,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'runtime': runtime,
      'status': status,
      'vote_average': voteAverage,
      'isShow': isShow,
      'origin_country': originCountry,
      'timestamp': timestamp,
      'collectionId': collectionId
    };
  }
}
