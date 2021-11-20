import 'package:equatable/equatable.dart';
import 'package:watchnow/data/models/episode_model.dart';
import 'package:watchnow/domain/entities/season_detail.dart';

class SeasonDetailModel extends Equatable {
  SeasonDetailModel({
    required this.posterPath,
    required this.name,
    required this.overview,
    required this.episodes,
    required this.seasonNumber,
  });

  final String? posterPath;
  final String name;
  final String overview;
  final List<EpisodeModel> episodes;
  final int seasonNumber;

  factory SeasonDetailModel.fromJson(Map<String, dynamic> json) =>
      SeasonDetailModel(
        posterPath: json["poster_path"] ?? '',
        name: json["name"] ?? '',
        overview: json["overview"] ?? '',
        episodes: List<EpisodeModel>.from(
          json["episodes"].map(
            (episode) => EpisodeModel.fromJson(episode),
          ) ?? List.empty(),
        ),
        seasonNumber: json["season_number"] ?? -1,
      );

  Map<String, dynamic> toJson() => {
        "poster_path": posterPath,
        "name": name,
        "overview": overview,
        "episodes":
            List<dynamic>.from(episodes.map((episode) => episode.toJson())),
        "season_number": seasonNumber,
      };

  SeasonDetail toEntity() => SeasonDetail(
        posterPath: this.posterPath,
        name: this.name,
        overview: this.overview,
        episodes: this.episodes.map((episode) => episode.toEntity()).toList(),
        seasonNumber: this.seasonNumber,
      );

  @override
  List<Object?> get props =>
      [posterPath, name, overview, episodes, seasonNumber];
}
