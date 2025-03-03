part of 'movie_bloc.dart';

abstract class MovieState {
  const MovieState();

  Map<String, dynamic> toJson();

  factory MovieState.fromJson(Map<String, dynamic> json) {
    switch (json['runtimeType']) {
      case 'MovieLoaded':
        return MovieLoaded.fromJson(json);
      case 'MovieError':
        return MovieError.fromJson(json);
      case 'MovieLoading':
        return const MovieLoading();
      default:
        return const MovieInitial();
    }
  }
}

class MovieInitial extends MovieState {
  const MovieInitial();

  @override
  Map<String, dynamic> toJson() => {'runtimeType': 'MovieInitial'};
}

class MovieLoading extends MovieState {
  const MovieLoading();

  @override
  Map<String, dynamic> toJson() => {'runtimeType': 'MovieLoading'};
}

class MovieLoaded extends MovieState {
  final List<Movie> allMovies;
  final String searchQuery;

  const MovieLoaded({
    required this.allMovies,
    this.searchQuery = '',
  });

  factory MovieLoaded.fromState(
    MovieState state, {
    List<Movie>? allMovies,
    String? searchQuery,
  }) {
    return MovieLoaded(
      allMovies: allMovies ?? (state is MovieLoaded ? state.allMovies : []),
      searchQuery:
          searchQuery ?? (state is MovieLoaded ? state.searchQuery : ''),
    );
  }

  factory MovieLoaded.fromJson(Map<String, dynamic> json) {
    return MovieLoaded(
      allMovies:
          (json['allMovies'] as List).map((e) => Movie.fromJson(e)).toList(),
      searchQuery: json['searchQuery'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'runtimeType': 'MovieLoaded',
      'allMovies': allMovies.map((e) => e.toJson()).toList(),
      'searchQuery': searchQuery,
    };
  }

  List<Movie> get movies => searchQuery.isEmpty
      ? allMovies
      : allMovies
          .where((movie) =>
              movie.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

  @override
  List<Object> get props => [allMovies, searchQuery];
}

class MovieError extends MovieState {
  final String message;

  const MovieError({required this.message});

  factory MovieError.fromState(MovieState state, {required String message}) {
    return MovieError(message: message);
  }

  factory MovieError.fromJson(Map<String, dynamic> json) {
    return MovieError(
      message: json['message'] ?? 'Unknown error',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'runtimeType': 'MovieError',
      'message': message,
    };
  }

  @override
  List<Object> get props => [message];
}
