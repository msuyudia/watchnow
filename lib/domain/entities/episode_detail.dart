import 'package:equatable/equatable.dart';

class EpisodeDetail extends Equatable {
  EpisodeDetail({
    required this.id,
    required this.stillPath,
    required this.name,
    required this.voteAverage,
    required this.overview,
  });

  final int id;
  final String? stillPath;
  final String name;
  final double voteAverage;
  final String overview;

  @override
  List<Object> get props => [id, stillPath ?? '', name, voteAverage, overview];
}
