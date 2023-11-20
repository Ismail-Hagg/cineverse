import 'dart:convert';
import 'package:cineverse/models/season_model.dart';
import 'package:http/http.dart' as http;

class SeasonService {
  Future<SeasonModel> getHomeInfo({required String link}) async {
    SeasonModel model = SeasonModel();
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = SeasonModel.fromMap(result);
        // print('from service   ===  ${result['season_number']}');
      } else {
        model = SeasonModel(isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return SeasonModel(isError: true, errorMessage: e.toString());
    }
  }
}
