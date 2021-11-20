import 'package:equatable/equatable.dart';
import 'package:watchnow/domain/entities/episode.dart';

class EpisodeModel extends Equatable {
  EpisodeModel({
    required this.stillPath,
    required this.name,
    required this.voteAverage,
    required this.episodeNumber,
  });

  final String stillPath;
  final String name;
  final double voteAverage;
  final int episodeNumber;

  factory EpisodeModel.fromJson(Map<String, dynamic> json) => EpisodeModel(
        stillPath: json["still_path"] ?? '',
        name: json["name"] ?? '',
        voteAverage: json["vote_average"] ?? '',
        episodeNumber: json["episode_number"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "still_path": stillPath,
        "name": name,
        "vote_average": voteAverage,
        "episode_number": episodeNumber,
      };

  Episode toEntity() => Episode(
        stillPath: this.stillPath,
        name: this.name,
        voteAverage: this.voteAverage,
        episodeNumber: this.episodeNumber,
      );

  @override
  List<Object?> get props => [stillPath, name, voteAverage, episodeNumber];
}
