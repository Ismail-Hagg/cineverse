class CastModel {
  List<Cast>? cast;
  bool? isError;
  String? errorMessage;

  CastModel({this.cast, this.isError, this.errorMessage});

  CastModel.fromMap(Map<String, dynamic> json) {
    isError = false;
    errorMessage = '';
    if (json['cast'] != null) {
      cast = <Cast>[];
      json['cast'].forEach((v) {
        cast!.add(Cast.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (cast != null) {
      data['cast'] = cast!.map((v) => v.toMap()).toList();
    }

    return data;
  }
}

class Cast {
  int? id;
  String? name;
  String? profilePath;
  String? character;
  String? creditId;

  Cast({
    this.id,
    this.name,
    this.profilePath,
    this.character,
    this.creditId,
  });

  Cast.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profilePath = json['profile_path'];
    character = json['character'] == '' || json['character'] == ''
        ? ''
        : json['character'];
    creditId = json['credit_id'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'profile_path': profilePath,
      'character': character,
      'credit_id': creditId,
    };
  }
}
