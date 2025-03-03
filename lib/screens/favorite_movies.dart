import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/movie_bloc.dart';
import '../widgets/empty_state.dart';
import '../widgets/movie_card.dart';

class FavoriteMoviesScreen extends StatelessWidget {
  const FavoriteMoviesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoaded) {
            final favorites = state.movies.where((m) => m.isFavorite).toList();
            if (favorites.isEmpty) {
              return const EmptyState(message: 'No favorites yet');
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) =>
                  MovieCard(movie: favorites[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}