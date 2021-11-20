import 'package:equatable/equatable.dart';
import 'package:watchnow/domain/entities/genre.dart';
import 'package:watchnow/domain/entities/season.dart';

class TVShowDetail extends Equatable {
  TVShowDetail({
    required this.id,
    required this.posterPath,
    required this.name,
    required this.genres,
    required this.voteAverage,
    required this.overview,
    required this.seasons,
  });

  final int id;
  final String? posterPath;
  final String name;
  final List<Genre> genres;
  final double voteAverage;
  final String overview;
  final List<Season> seasons;

  @override
  List<Object?> get props => [
        id,
        posterPath,
        name,
        genres,
        voteAverage,
        overview,
        seasons,
      ];
}
