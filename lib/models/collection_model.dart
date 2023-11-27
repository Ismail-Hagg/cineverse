import 'package:cineverse/models/result_details_model.dart';

class CollectionModel {
  int? id;
  List<ResultsDetail>? results;
  bool? isError;
  String? errorMessage;
  CollectionModel({this.id, this.results, this.isError, this.errorMessage});

  CollectionModel.fromMap(Map<String, dynamic> json) {
    id = json["id"];
    results = <ResultsDetail>[];
    json['parts'].forEach((v) {
      results!.add(ResultsDetail.fromMap(v));
    });
    isError = false;
    errorMessage = '';
  }
}
