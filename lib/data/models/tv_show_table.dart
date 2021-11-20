import 'package:equatable/equatable.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/entities/tv_show_detail.dart';

class TVShowTable extends Equatable {
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;

  TVShowTable({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  factory TVShowTable.fromEntity(TVShowDetail tvShow) => TVShowTable(
        id: tvShow.id,
        name: tvShow.name,
        overview: tvShow.overview,
        posterPath: tvShow.posterPath,
      );

  factory TVShowTable.fromMap(Map<String, dynamic> map) => TVShowTable(
        id: map['id'],
        name: map['name'],
        overview: map['overview'],
        posterPath: map['posterPath'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'posterPath': posterPath,
      };

  TVShow toEntity() => TVShow(
        id: id,
        name: name,
        overview: overview,
        posterPath: posterPath,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, overview, posterPath];
}
