import 'dart:convert';
import 'package:cineverse/models/episode_omdel.dart';
import 'package:http/http.dart' as http;

class EpisodeKeepingService {
  Future<EpisodeModeL> getData(
      {required String link, required String lan, required bool isFire}) async {
    EpisodeModeL model = EpisodeModeL();
    dynamic result = '';
    var url = Uri.parse(link + lan.replaceAll('_', '-'));
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);

        model = EpisodeModeL.fromMap(result, isFire);
      } else {
        model =
            EpisodeModeL(isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return EpisodeModeL(isError: true, errorMessage: e.toString());
    }
  }
}
