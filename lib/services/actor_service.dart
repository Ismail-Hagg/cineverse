import 'dart:convert';
import 'package:cineverse/models/actor_model.dart';
import 'package:http/http.dart' as http;

class ActorService {
  Future<ActorModel> getHomeInfo({required String link}) async {
    ActorModel model = ActorModel();
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = ActorModel.fromMap(result);
      } else {
        model = ActorModel(
          isError: true,
          errorMessage: 'status code not 200',
        );
      }
      return model;
    } catch (e) {
      return ActorModel(isError: true, errorMessage: e.toString());
    }
  }
}
