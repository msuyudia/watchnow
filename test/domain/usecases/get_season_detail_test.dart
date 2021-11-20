import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/domain/usecases/get_season_detail.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeasonDetail usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = GetSeasonDetail(mockTVShowRepository);
  });

  final tId = 1;
  final tSeasonNumber = 1;

  test('should get season detail from the repository', () async {
    // arrange
    when(mockTVShowRepository.getSeasonDetail(tId, tSeasonNumber))
        .thenAnswer((_) async => Right(testSeasonDetail));
    // act
    final result = await usecase.execute(tId, tSeasonNumber);
    // assert
    expect(result, Right(testSeasonDetail));
  });
}
