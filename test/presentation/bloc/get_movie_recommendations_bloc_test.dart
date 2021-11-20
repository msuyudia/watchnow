import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_movie_recommendations.dart';
import 'package:watchnow/presentation/bloc/get_movie_recommendations_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_movie_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetMovieRecommendations])
void main() {
  late GetMovieRecommendationsBloc getMovieRecommendationsBloc;
  late MockGetMovieRecommendations mockGetMovieRecommendations;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    getMovieRecommendationsBloc =
        GetMovieRecommendationsBloc(mockGetMovieRecommendations);
  });

  test('initial state should be empty', () {
    expect(getMovieRecommendationsBloc.state, EmptyState());
  });

  final tId = 1;

  blocTest<GetMovieRecommendationsBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testMovieList));
      return getMovieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(GetMovieRecommendationsEvent(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      MoviesHasDataState(testMovieList),
    ],
    verify: (bloc) => GetMovieRecommendationsEvent(tId).props,
  );

  blocTest<GetMovieRecommendationsBloc, BlocState>(
    'Should emit [Loading, Error] when get movie recommendations is unsuccessful',
    build: () {
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getMovieRecommendationsBloc;
    },
    act: (bloc) => bloc.add(GetMovieRecommendationsEvent(tId)),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetMovieRecommendationsEvent(tId).props,
  );
}
