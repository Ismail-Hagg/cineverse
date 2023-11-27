import 'dart:convert';
import 'package:cineverse/models/collection_model.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class CollectionService {
  Future<CollectionModel> getHomeInfo({required String link}) async {
    CollectionModel model = CollectionModel();
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = CollectionModel.fromMap(result);
      } else {
        model =
            CollectionModel(isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return CollectionModel(isError: true, errorMessage: e.toString());
    }
  }
}
