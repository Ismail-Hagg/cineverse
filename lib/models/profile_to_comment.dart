import 'package:cineverse/models/user_model.dart';

class ProfileToComment {
  bool isMe;
  UserModel user;
  final Map<String, List<String>> map;
  final bool fromProfile;

  ProfileToComment(
      {required this.isMe,
      required this.user,
      required this.map,
      required this.fromProfile});
}
