import 'package:cloud_firestore/cloud_firestore.dart';

class EpisodeModeL {
  String? name;
  int? id;
  String? pic;
  int? myEpisode;
  int? mySeason;
  int? episode;
  int? season;
  String? status;
  int? nextepisode;
  int? nextSeason;
  String? nextEpisodeDate;
  String? overView;
  double? voteAverage;
  String? releaseDate;
  bool? isError;
  String? errorMessage;
  Timestamp? change;
  bool? isUpdated;
  String? token;
  List<dynamic>? refList;
  EpisodeModeL(
      {this.name,
      this.id,
      this.pic,
      this.myEpisode,
      this.mySeason,
      this.episode,
      this.season,
      this.status,
      this.nextepisode,
      this.nextSeason,
      this.nextEpisodeDate,
      this.overView,
      this.voteAverage,
      this.releaseDate,
      this.isError,
      this.errorMessage,
      this.change,
      this.isUpdated,
      this.token,
      this.refList});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
      'pic': pic,
      'myEpisode': myEpisode,
      'mySeason': mySeason,
      'episode': episode,
      'season': season,
      'status': status,
      'nextepisode': nextepisode,
      'nextSeason': nextSeason,
      'nextEpisodeDate': nextEpisodeDate,
      'overView': overView,
      'voteAverage': voteAverage,
      'releaseDate': releaseDate,
      'change': change,
      'isUpdated': isUpdated,
      'token': token,
      'refList': refList
    };
  }

  factory EpisodeModeL.fromMap(Map<String, dynamic> map, bool isFire) {
    return EpisodeModeL(
      name: map['name'],
      id: map['id'],
      pic: isFire ? map['pic'] : map['poster_path'] ?? '',
      myEpisode: isFire ? map['myEpisode'] : 1,
      mySeason: isFire ? map['mySeason'] : 1,
      episode: isFire
          ? map['episode']
          : map['last_episode_to_air']['episode_number'] ?? 0,
      season: isFire
          ? map['season']
          : map['last_episode_to_air']['season_number'] ?? 0,
      status: map['status'],
      nextepisode: isFire
          ? map['nextepisode']
          : map['next_episode_to_air'] != null
              ? map['next_episode_to_air']['episode_number'] ?? 0
              : 0,
      nextSeason: isFire
          ? map['nextSeason']
          : map['next_episode_to_air'] != null
              ? map['next_episode_to_air']['season_number'] ?? 0
              : 0,
      nextEpisodeDate: isFire
          ? map['nextEpisodeDate']
          : map['next_episode_to_air'] != null
              ? map['next_episode_to_air']['air_date'] ?? ''
              : '',
      overView: isFire ? map['overView'] : map['overview'] ?? '',
      voteAverage: map['vote_average'] ?? 0.0,
      releaseDate: isFire ? map['releaseDate'] : map['first_air_date'] ?? '',
      change: isFire ? map['change'] : Timestamp.now(),
      isError: false,
      errorMessage: '',
      isUpdated: isFire ? map['isUpdated'] : false,
      token: isFire ? map['token'] : '',
      refList: isFire ? map['refList'] : [],
    );
  }
}
