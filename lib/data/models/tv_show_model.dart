import 'package:equatable/equatable.dart';
import 'package:watchnow/domain/entities/tv_show.dart';

class TVShowModel extends Equatable {
  TVShowModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  final int id;
  final String name;
  final String overview;
  final String? posterPath;

  factory TVShowModel.fromJson(Map<String, dynamic> json) => TVShowModel(
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath
      };

  TVShow toEntity() => TVShow(
        id: this.id,
        name: this.name,
        overview: this.overview,
        posterPath: this.posterPath,
      );

  @override
  List<Object?> get props => [id, name, overview, posterPath];
}
