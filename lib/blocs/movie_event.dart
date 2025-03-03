part of 'movie_bloc.dart';

// Base class for all movie-related events in the Bloc
abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => []; // Ensures Equatable properly compares event instances
}

// Event to trigger loading movies from API or local storage
class LoadMovies extends MovieEvent {}

// Event to toggle the favorite status of a movie
class ToggleFavorite extends MovieEvent {
  final int movieId; // ID of the movie to be toggled

  const ToggleFavorite(this.movieId);

  @override
  List<Object> get props => [movieId]; // Ensures state updates only when movieId changes
}

// Event to search for movies based on a query
class SearchMovies extends MovieEvent {
  final String query; // Search query entered by the user

  const SearchMovies(this.query);

  @override
  List<Object> get props => [query]; // Ensures state updates only when query changes
}