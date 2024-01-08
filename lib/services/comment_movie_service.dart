import 'dart:convert';
import 'package:cineverse/models/movie_detales_model.dart';
import 'package:cineverse/utils/constants.dart';
import 'package:http/http.dart' as http;

class CommentMovieService {
  Future<(MovieDetaleModel, MovieDetaleModel)> getHomeInfo(
      {required String id}) async {
    Uri movie =
        Uri.parse('https://api.themoviedb.org/3/movie/$id?api_key=$apiKey');
    Uri tv = Uri.parse('https://api.themoviedb.org/3/tv/$id?api_key=$apiKey');
    MovieDetaleModel movieOb = MovieDetaleModel();
    MovieDetaleModel tvOb = MovieDetaleModel();

    try {
      var movieResponse = await http.get(movie);
      if (movieResponse.statusCode == 200) {
        movieOb = MovieDetaleModel.fromMap(jsonDecode(movieResponse.body));
      } else {
        movieOb = MovieDetaleModel(
            isError: true, errorMessage: 'status code not 200');
      }
    } catch (e) {
      movieOb = MovieDetaleModel(isError: true, errorMessage: e.toString());
    }
    try {
      var tvResponse = await http.get(tv);

      if (tvResponse.statusCode == 200) {
        tvOb = MovieDetaleModel.fromMap(jsonDecode(tvResponse.body));
      } else {
        tvOb = MovieDetaleModel(
            isError: true, errorMessage: 'status code not 200');
      }
    } catch (e) {
      tvOb = MovieDetaleModel(isError: true, errorMessage: e.toString());
    }
    return (movieOb, tvOb);
  }
}
