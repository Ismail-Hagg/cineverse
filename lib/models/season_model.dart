class SeasonModel {
  String? airDate;
  List<EpisodeModel>? episodes;
  String? name;
  int? id;
  String? posterPath;
  int? seasonNumber;
  double? voteAverage;
  String? overview;
  bool? isError;
  String? errorMessage;
  SeasonModel(
      {this.airDate,
      this.episodes,
      this.name,
      this.id,
      this.posterPath,
      this.seasonNumber,
      this.voteAverage,
      this.errorMessage,
      this.overview,
      this.isError});

  factory SeasonModel.fromMap(Map<String, dynamic> map) {
    List<EpisodeModel> lst = [];
    if (map['episodes'] != null || map['episodes'] != []) {
      map['episodes'].forEach((v) {
        lst.add(EpisodeModel.fromMap(v));
      });
    }
    return SeasonModel(
      airDate: map['air_date'] != null ? map['air_date'] as String : '',
      episodes: lst,
      name: map['name'] != null ? map['name'] as String : '',
      overview: map['overview'] != null ? map['overview'] as String : '',
      id: map['id'] != null ? map['id'] as int : 0,
      posterPath:
          map['poster_path'] != null ? map['poster_path'] as String : '',
      seasonNumber:
          map['season_number'] != null ? map['season_number'] as int : 0,
      voteAverage:
          map['vote_average'] != null ? map['vote_average'] as double : 0.0,
      isError: false,
      errorMessage: '',
    );
  }
}

class EpisodeModel {
  final String airDate;
  final int episodeNumber;
  final String name;
  final String overview;
  final int id;
  final int runTime;
  final int seasonNumber;
  final String posterPath;
  final double voteAverage;
  EpisodeModel({
    required this.airDate,
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.id,
    required this.runTime,
    required this.seasonNumber,
    required this.posterPath,
    required this.voteAverage,
  });

  factory EpisodeModel.fromMap(Map<String, dynamic> map) {
    return EpisodeModel(
      airDate: map['air_date'].runtimeType == Null || map['air_date'] == null
          ? ''
          : map['air_date'],
      episodeNumber: map['episode_number'].runtimeType == Null ||
              map['episode_number'] == null
          ? 0
          : map['episode_number'],
      name: map['name'].runtimeType == Null || map['name'] == null
          ? ''
          : map['name'],
      overview: map['overview'].runtimeType == Null || map['overview'] == null
          ? ''
          : map['overview'],
      id: map['id'].runtimeType == Null || map['id'] == null ? 0 : map['id'],
      runTime: map['runtime'].runtimeType == Null ? 0 : map['runtime'] ?? 0,
      seasonNumber: map['season_number'].runtimeType == Null ||
              map['season_number'] == null
          ? 0
          : map['season_number'],
      posterPath:
          map['still_path'].runtimeType == Null || map['still_path'] == null
              ? ''
              : map['still_path'],
      voteAverage:
          map['vote_average'].runtimeType == Null || map['vote_average'] == null
              ? 0.0
              : map['vote_average'],
    );
  }
}
