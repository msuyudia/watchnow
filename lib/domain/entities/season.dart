import 'package:equatable/equatable.dart';

class Season extends Equatable {
  Season({
    required this.posterPath,
    required this.name,
    required this.seasonNumber,
  });

  final String? posterPath;
  final String name;
  final int seasonNumber;

  @override
  List<Object> get props => [posterPath ?? '', name, seasonNumber];
}
