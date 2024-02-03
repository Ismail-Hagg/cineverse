import 'dart:convert';
import 'package:http/http.dart' as http;

class ActorSearch {
  Future<List<dynamic>> getHomeInfo({required String link}) async {
    List<dynamic> model = [];
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = result['total_results'] != [] ? result['results'] : [];
      } else {
        model = [];
      }
      return model;
    } catch (e) {
      print('========$e');
      return [];
    }
  }
}
