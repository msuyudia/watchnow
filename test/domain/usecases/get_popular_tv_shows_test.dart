import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/domain/usecases/get_popular_tv_shows.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVShows usecase;
  late MockTVShowRepository mockTVShowRepository;

  setUp(() {
    mockTVShowRepository = MockTVShowRepository();
    usecase = GetPopularTVShows(mockTVShowRepository);
  });

  final tTVShows = <TVShow>[];

  group('GetPopularTVShows Tests', () {
    group('execute', () {
      test(
          'should get list of tv shows from the repository when execute function is called',
          () async {
        // arrange
        when(mockTVShowRepository.getPopularTVShows())
            .thenAnswer((_) async => Right(tTVShows));
        // act
        final result = await usecase.execute();
        // assert
        expect(result, Right(tTVShows));
      });
    });
  });
}
