import 'dart:io';
import 'package:hive/hive.dart';
import '../models/movie.dart';
import '../services/connectivity_service.dart';
import '../services/api_service.dart';

class MovieRepository {
  final APIService apiService;
  final Box<Movie> movieBox;
  final ConnectivityService connectivity;

  MovieRepository({
    required this.apiService,
    required this.movieBox,
    required this.connectivity,
  });

  Future<List<Movie>> getMovies() async {
    try {
      if (await connectivity.isConnected) {
        final movies = await apiService.fetchMovies();
        await _persistMovies(movies);
        return movies;
      }
      return movieBox.values.toList();
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Failed to fetch movies');
    } on HiveError catch (e) {
      throw Exception('Storage error: ${e.message}');
    }
  }

  Future<void> toggleFavorite(int movieId) async {
    try {
      final movie = movieBox.values.firstWhere((m) => m.id == movieId);
      await movieBox.put(movieId, movie.copyWith(isFavorite: !movie.isFavorite));
    } on StateError {
      throw Exception('Movie not found');
    }
  }

  Future<void> _persistMovies(List<Movie> movies) async {
    await movieBox.clear();
    await movieBox.addAll(movies);
  }
}