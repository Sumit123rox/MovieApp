import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'blocs/movie_bloc.dart';
import 'models/movie.dart';
import 'repositories/movie_repository.dart';
import 'screens/movie_list.dart';
import 'services/connectivity_service.dart';
import 'services/api_service.dart';

void main() async {
  // Ensures that Flutter bindings are initialized before running the app.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive (local database for persistent storage)
  await Hive.initFlutter(); // Initializes Hive for local storage
  Hive.registerAdapter(MovieAdapter()); // Registers adapter for the Movie model to enable object storage
  await Hive.openBox<Movie>('movies'); // Opens a Hive box to store movie objects persistently

  // Initialize HydratedBloc for state persistence
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationCacheDirectory(), // Uses the application cache directory to store hydrated state
  );

  // Runs the Flutter application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Provides API service dependency to the app
        RepositoryProvider(create: (_) => APIService()),

        // Provides connectivity service for network status checks
        RepositoryProvider(create: (_) => ConnectivityService()),

        // Provides the MovieRepository, which handles fetching and storing movie data
        RepositoryProvider(
          create: (context) => MovieRepository(
            apiService: RepositoryProvider.of<APIService>(context), // Injects API service for TMDB calls
            movieBox: Hive.box<Movie>('movies'), // Uses Hive to persist movies locally
            connectivity: RepositoryProvider.of<ConnectivityService>(context), // Injects connectivity service for network-aware operations
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Provides the MovieBloc, which manages state related to movies
          BlocProvider(
            create: (context) => MovieBloc(
              repository: RepositoryProvider.of<MovieRepository>(context), // Injects movie repository
            )..add(LoadMovies()), // Triggers an event to load movies when the app starts
          ),
        ],
        child: MaterialApp(
          title: 'Movie App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity, // Adapts visual density based on platform
          ),
          home: const MovieListScreen(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}