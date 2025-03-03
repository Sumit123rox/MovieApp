import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/movie_bloc.dart';
import '../models/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                    color: Colors.white,
                  ),
                )),
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: 'https://image.tmdb.org/t/p/w1280${movie.posterPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(
                  movie.overview,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                BlocBuilder<MovieBloc, MovieState>(
                  builder: (context, state) {
                    return IconButton(
                      icon: Icon(
                        movie.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.red,
                        size: 32,
                      ),
                      onPressed: () => context
                          .read<MovieBloc>()
                          .add(ToggleFavorite(movie.id)),
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
