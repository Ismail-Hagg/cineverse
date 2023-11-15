class ResultsDetail {
  String? backdropPath;
  int? id;
  String? overview;
  String? posterPath;
  String? releaseDate;
  String? title;
  double? voteAverage;
  bool? isShow;
  String? mediaType;
  List<dynamic>? genreIds;

  ResultsDetail(
      {this.backdropPath,
      this.id,
      this.overview,
      this.posterPath,
      this.releaseDate,
      this.title,
      required this.voteAverage,
      this.mediaType,
      this.genreIds,
      this.isShow});

  ResultsDetail.fromMap(Map<String, dynamic> json) {
    double voteAve = json['vote_average'] != null
        ? double.parse(json['vote_average'].toString()).toDouble()
        : 0.0;
    String relDate =
        json['release_date'] ?? json['first_air_date'] ?? 'unknown';
    backdropPath = json['backdrop_path'];
    id = json['id'];
    overview = json['overview'];
    posterPath = json['media_type'] == 'person'
        ? json['profile_path']
        : json['poster_path'];
    releaseDate = relDate != 'unknown' && relDate != ''
        ? relDate.substring(0, 4)
        : relDate != ''
            ? relDate
            : 'unknown';
    title = json['title'] ?? json['name'];
    voteAverage = double.parse(voteAve.toStringAsFixed(1));
    isShow = json['first_air_date'] != null ? true : false;
    mediaType = json['media_type'] ?? '';
    genreIds = json['genre_ids'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'backdrop_path': backdropPath,
      'id': id,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'vote_average': voteAverage,
      'genre_ids': genreIds
    };
  }
}
