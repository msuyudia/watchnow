import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/usecases/get_top_rated_tv_shows.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTVShows usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = GetTopRatedTVShows(mockTVShowRepository);
  });

  final tTVShows = <TVShow>[];

  test('should get list of tv shows from repository', () async {
    // arrange
    when(mockTVShowRepository.getTopRatedTVShows())
        .thenAnswer((_) async => Right(tTVShows));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVShows));
  });
}
