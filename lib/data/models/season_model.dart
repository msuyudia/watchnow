import 'package:equatable/equatable.dart';
import 'package:watchnow/domain/entities/season.dart';

class SeasonModel extends Equatable {
  SeasonModel({
    required this.posterPath,
    required this.name,
    required this.seasonNumber,
  });

  final String? posterPath;
  final String name;
  final int seasonNumber;

  factory SeasonModel.fromJson(Map<String, dynamic> json) => SeasonModel(
        posterPath: json["poster_path"] ?? '',
        name: json["name"] ?? 'Season Name Empty',
        seasonNumber: json["season_number"] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "poster_path": posterPath,
        "name": name,
        "season_number": seasonNumber,
      };

  Season toEntity() => Season(
        posterPath: this.posterPath,
        name: this.name,
        seasonNumber: this.seasonNumber,
      );

  @override
  List<Object?> get props => [posterPath, name, seasonNumber];
}
