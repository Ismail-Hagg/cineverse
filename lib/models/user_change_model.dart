class UserChange {
  String userName;
  String link;
  String local;
  String userId;
  String avatarType;
  UserChange(
      {required this.userName,
      required this.link,
      required this.local,
      required this.userId,
      required this.avatarType});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'link': link,
      'local': local,
      'userId': userId,
      'avatarType': avatarType
    };
  }
}
