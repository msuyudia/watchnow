import 'package:equatable/equatable.dart';
import 'package:watchnow/data/models/genre_model.dart';
import 'package:watchnow/data/models/season_model.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';

class TVShowDetailModel extends Equatable {
  TVShowDetailModel({
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
  final List<GenreModel> genres;
  final double voteAverage;
  final String overview;
  final List<SeasonModel> seasons;

  factory TVShowDetailModel.fromJson(Map<String, dynamic> json) =>
      TVShowDetailModel(
        id: json["id"],
        posterPath: json["poster_path"],
        name: json["name"],
        genres: List<GenreModel>.from(
          json["genres"].map(
            (x) => GenreModel.fromJson(x),
          ),
        ),
        voteAverage: json["vote_average"],
        overview: json["overview"],
        seasons: List<SeasonModel>.from(
          json["seasons"].map(
            (x) => SeasonModel.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "poster_path": posterPath,
        "name": name,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "vote_average": voteAverage,
        "overview": overview,
        "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
      };

  TVShowDetail toEntity() => TVShowDetail(
        id: this.id,
        posterPath: this.posterPath,
        name: this.name,
        genres: this.genres.map((genre) => genre.toEntity()).toList(),
        voteAverage: this.voteAverage,
        overview: this.overview,
        seasons: this.seasons.map((season) => season.toEntity()).toList(),
      );

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
