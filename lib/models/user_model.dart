import '../utils/enums.dart';

class UserModel {
  String? userName;
  String? email;
  String? onlinePicPath;
  String? localPicPath;
  String? userId;
  String? language;
  bool? isError;
  String? errorMessage;
  String? messagingToken;
  LogState? state;
  LoginMethod? method;
  String? phoneNumber;
  Gender? gender;
  String? birthday;
  AvatarType? avatarType;
  ChosenTheme? theme;
  List<String>? movieWatchList;
  List<String>? showWatchList;
  List<String>? favs;
  List<String>? watching;
  List<String>? commentLike;
  List<String>? commentDislike;
  List<String>? follwers;
  List<String>? following;

  UserModel(
      {this.userName,
      this.email,
      this.onlinePicPath,
      this.localPicPath,
      this.userId,
      this.language,
      this.isError,
      this.messagingToken,
      this.state,
      this.gender,
      this.phoneNumber,
      this.birthday,
      this.errorMessage,
      this.method,
      this.avatarType,
      this.movieWatchList,
      this.showWatchList,
      this.following,
      this.follwers,
      this.watching,
      this.favs,
      this.commentDislike,
      this.theme,
      this.commentLike});

  toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'onlinePicPath': onlinePicPath,
      'localPicPath': localPicPath,
      'userId': userId,
      'language': language,
      'isError': isError,
      'messagingToken': messagingToken,
      'errorMessage': errorMessage,
      'phoneNumber': phoneNumber,
      'state': state.toString(),
      'method': method.toString(),
      'gender': gender.toString(),
      'avatarType': avatarType.toString(),
      'theme': theme.toString(),
      'birthday': birthday,
      'movieWatchList': movieWatchList!.join(','),
      'showWatchList': showWatchList!.join(','),
      'favs': favs!.join(','),
      'watching': watching!.join(','),
      'commentLike': commentLike!.join(','),
      'commentDislike': commentDislike!.join(','),
      'following': following!.join(','),
      'follwers': follwers!.join(','),
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
        following: map['following'] != null && map['following'] != []
            ? map['following'].split(',')
            : [],
        follwers: map['follwers'] != null && map['follwers'] != []
            ? map['follwers'].split(',')
            : [],
        userName: map['userName'],
        email: map['email'],
        onlinePicPath: map['onlinePicPath'],
        localPicPath: map['localPicPath'],
        userId: map['userId'],
        language: map['language'],
        isError: map['isError'],
        messagingToken: map['messagingToken'],
        state: LogState.values.firstWhere((e) => e.toString() == map['state']),
        method:
            LoginMethod.values.firstWhere((e) => e.toString() == map['method']),
        gender: Gender.values.firstWhere((e) => e.toString() == map['gender']),
        avatarType: AvatarType.values
            .firstWhere((e) => e.toString() == map['avatarType']),
        theme:
            ChosenTheme.values.firstWhere((e) => e.toString() == map['theme']),
        birthday: map['birthday'],
        phoneNumber: map['phoneNumber'],
        movieWatchList:
            map['movieWatchList'] != [] ? map['movieWatchList'].split(',') : [],
        showWatchList:
            map['showWatchList'] != [] ? map['showWatchList'].split(',') : [],
        favs: map['favs'] != [] ? map['favs'].split(',') : [],
        watching: map['watching'] != [] ? map['watching'].split(',') : [],
        commentLike:
            map['commentLike'] != [] ? map['commentLike'].split(',') : [],
        commentDislike:
            map['commentDislike'] != [] ? map['commentDislike'].split(',') : [],
        errorMessage: map['errorMessage']);
  }
}
