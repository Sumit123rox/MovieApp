import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/movie_bloc.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/movie_card.dart';
import 'favorite_movies.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.sort)),
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    border: InputBorder.none,
                  ),
                  onChanged: (query) {
                    context.read<MovieBloc>().add(SearchMovies(query));
                  },
                )
                : const Text('Movies'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              if (_isSearching) {
                // Exit search mode
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                });
                context.read<MovieBloc>().add(SearchMovies(''));
                FocusScope.of(context).unfocus();
              } else {
                // Enter search mode
                setState(() => _isSearching = true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const FavoriteMoviesScreen(),
                  ),
                ),
          ),
        ],
      ),
      body: BlocConsumer<MovieBloc, MovieState>(
        listener: (context, state) {
          if (state is MovieError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is MovieLoading) return const LoadingShimmer();
          if (state is MovieError) return EmptyState(message: state.message);
          if (state is MovieLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: state.movies.length,
              itemBuilder:
                  (context, index) => MovieCard(movie: state.movies[index]),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
