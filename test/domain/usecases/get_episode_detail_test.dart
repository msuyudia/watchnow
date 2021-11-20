import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/domain/usecases/get_episode_detail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetEpisodeDetail usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = GetEpisodeDetail(mockTVShowRepository);
  });

  final tId = 1;
  final tSeasonNumber = 1;
  final tEpisodeNumber = 1;

  test('should get episode detail from the repository', () async {
    // arrange
    when(mockTVShowRepository.getEpisodeDetail(
            tId, tSeasonNumber, tEpisodeNumber))
        .thenAnswer((_) async => Right(testEpisodeDetail));
    // act
    final result = await usecase.execute(tId, tSeasonNumber, tEpisodeNumber);
    // assert
    expect(result, Right(testEpisodeDetail));
  });
}
