import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String? posterPath;
  @HiveField(3)
  final String overview;
  @HiveField(4)
  final bool isFavorite;

  Movie({
    required this.id,
    required this.title,
    this.posterPath,
    required this.overview,
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['posterPath'],
      overview: json['overview'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'isFavorite': isFavorite,
    };
  }

  Movie copyWith({bool? isFavorite}) => Movie(
    id: id,
    title: title,
    posterPath: posterPath,
    overview: overview,
    isFavorite: isFavorite ?? this.isFavorite,
  );
}