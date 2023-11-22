import 'package:cineverse/models/result_model.dart';

class Move {
  String? title;
  String? link;
  bool isSearch;
  ResultModel model;

  Move({this.title, this.link, required this.isSearch, required this.model});
}
