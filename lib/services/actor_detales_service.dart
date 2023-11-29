import 'dart:convert';
import 'package:cineverse/models/actor_model.dart';
import 'package:http/http.dart' as http;

class ActorDetaleService {
  Future<ActorDetale> getHomeInfo({required String link}) async {
    ActorDetale model = ActorDetale();
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = ActorDetale.fromMap(result);
      } else {
        model = ActorDetale(isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return ActorDetale(isError: true, errorMessage: e.toString());
    }
  }
}
