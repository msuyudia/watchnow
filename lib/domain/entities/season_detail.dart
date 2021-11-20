import 'package:equatable/equatable.dart';

import 'episode.dart';

class SeasonDetail extends Equatable {
  SeasonDetail({
    required this.posterPath,
    required this.name,
    required this.overview,
    required this.episodes,
    required this.seasonNumber,
  });

  final String? posterPath;
  final String name;
  final String overview;
  final List<Episode> episodes;
  final int seasonNumber;

  @override
  List<Object> get props => [posterPath ?? '', name, seasonNumber];
}
