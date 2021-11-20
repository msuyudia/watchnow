import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/usecases/get_tv_show_recommendations.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVShowRecommendations usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = GetTVShowRecommendations(mockTVShowRepository);
  });

  final tId = 1;
  final tTVShows = <TVShow>[];

  test('should get list of tv show recommendations from the repository',
      () async {
    // arrange
    when(mockTVShowRepository.getTVShowRecommendations(tId))
        .thenAnswer((_) async => Right(tTVShows));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTVShows));
  });
}
