import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends HydratedBloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc({required this.repository}) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SearchMovies>(_onSearchMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await repository.getMovies();
      emit(MovieLoaded.fromState(state, allMovies: movies));
    } catch (e) {
      emit(MovieError.fromState(state, message: e.toString()));
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<MovieState> emit) async {
    if (state is MovieLoaded) {
      try {
        await repository.toggleFavorite(event.movieId);
        final updatedMovies = (state as MovieLoaded).allMovies.map((movie) {
          return movie.id == event.movieId
              ? movie.copyWith(isFavorite: !movie.isFavorite)
              : movie;
        }).toList();
        emit(MovieLoaded.fromState(state, allMovies: updatedMovies));
      } catch (e) {
        emit(MovieError.fromState(state, message: 'Favorite update failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) async {
    if (state is MovieLoaded) {
      emit(MovieLoaded.fromState(state, searchQuery: event.query));
    }
  }

  @override
  MovieState? fromJson(Map<String, dynamic> json) => MovieState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(MovieState state) => state.toJson();
}