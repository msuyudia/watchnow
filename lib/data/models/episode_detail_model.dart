import 'package:equatable/equatable.dart';
import 'package:watchnow/domain/entities/episode_detail.dart';

class EpisodeDetailModel extends Equatable {
  EpisodeDetailModel({
    required this.id,
    required this.stillPath,
    required this.name,
    required this.voteAverage,
    required this.overview,
  });

  final int id;
  final String stillPath;
  final String name;
  final double voteAverage;
  final String overview;

  factory EpisodeDetailModel.fromJson(Map<String, dynamic> json) =>
      EpisodeDetailModel(
        id: json["id"],
        stillPath: json["still_path"],
        name: json["name"],
        voteAverage: json["vote_average"],
        overview: json["overview"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "still_path": stillPath,
        "name": name,
        "vote_average": voteAverage,
        "overview": overview,
      };

  EpisodeDetail toEntity() => EpisodeDetail(
        id: this.id,
        stillPath: this.stillPath,
        name: this.name,
        voteAverage: this.voteAverage,
        overview: this.overview,
      );

  @override
  List<Object?> get props => [id, stillPath, name, voteAverage, overview];
}
