import 'dart:convert';
import 'package:cineverse/models/result_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class HomePageService {
  Future<ResultModel> getHomeInfo(
      {required String link, required String language}) async {
    ResultModel model = ResultModel();
    dynamic result = '';
    var url = Uri.parse(link + language.replaceAll('_', '-'));
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = ResultModel.fromJson(result);
      } else {
        model = ResultModel(isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return ResultModel(isError: true, errorMessage: e.toString());
    }
  }
}
