import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_popular_movies.dart';
import 'package:watchnow/presentation/bloc/get_popular_movies_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late GetPopularMoviesBloc getPopularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    getPopularMoviesBloc = GetPopularMoviesBloc(mockGetPopularMovies);
  });

  test('initial state should be empty', () {
    expect(getPopularMoviesBloc.state, EmptyState());
  });

  blocTest<GetPopularMoviesBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return getPopularMoviesBloc;
    },
    act: (bloc) => bloc.add(GetPopularMoviesEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      MoviesHasDataState(testMovieList),
    ],
    verify: (bloc) => GetPopularMoviesEvent().props,
  );

  blocTest<GetPopularMoviesBloc, BlocState>(
    'Should emit [Loading, Error] when get popular movies is unsuccessful',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getPopularMoviesBloc;
    },
    act: (bloc) => bloc.add(GetPopularMoviesEvent()),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetPopularMoviesEvent().props,
  );
}
