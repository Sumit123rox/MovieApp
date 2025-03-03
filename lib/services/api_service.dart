import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie.dart';

class APIService {
  static const String _apiKey = 'your_api_key';
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((movie) => Movie(
        id: movie['id'],
        title: movie['title'],
        overview: movie['overview'],
        posterPath: movie['poster_path'],
      )).toList();
    }
    throw Exception('Failed to load movies');
  }
}