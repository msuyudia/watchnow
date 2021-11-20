import 'package:flutter_test/flutter_test.dart';
import 'package:watchnow/data/models/tv_show_model.dart';
import 'package:watchnow/domain/entities/tv_show.dart';

void main() {
  final tTVShowModel = TVShowModel(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
  );

  final tTVShow = TVShow(
    id: 1,
    name: 'name',
    overview: 'overview',
    posterPath: 'posterPath',
  );

  test('should be a subclass of TV Show entity', () async {
    final result = tTVShowModel.toEntity();
    expect(result, tTVShow);
  });
}
