import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/usecases/search_tv_shows.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTVShows usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = SearchTVShows(mockTVShowRepository);
  });

  final tTVShows = <TVShow>[];
  final tQuery = 'Gotham';

  test('should get list of tv shows from the repository', () async {
    // arrange
    when(mockTVShowRepository.searchTVShows(tQuery))
        .thenAnswer((_) async => Right(tTVShows));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTVShows));
  });
}
