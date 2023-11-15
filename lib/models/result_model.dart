import 'package:cineverse/models/result_details_model.dart';

class ResultModel {
  int? page;
  List<ResultsDetail>? results;
  int? totalPages;
  int? totalResults;

  bool? isError;
  String? errorMessage;

  ResultModel(
      {this.page,
      this.results,
      this.totalPages,
      this.totalResults,
      this.isError,
      this.errorMessage});

  ResultModel.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      results = <ResultsDetail>[];
      json['results'].forEach((v) {
        results!.add(ResultsDetail.fromMap(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
    isError = false;
    errorMessage = '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    if (results != null) {
      data['results'] = results!.map((v) => v.toMap()).toList();
    }
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}
