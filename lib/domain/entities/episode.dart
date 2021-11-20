import 'package:equatable/equatable.dart';

class Episode extends Equatable {
  Episode({
    required this.stillPath,
    required this.name,
    required this.voteAverage,
    required this.episodeNumber,
  });

  final String? stillPath;
  final String name;
  final double voteAverage;
  final int episodeNumber;

  @override
  List<Object> get props =>
      [stillPath ?? '', name, voteAverage, episodeNumber];
}
