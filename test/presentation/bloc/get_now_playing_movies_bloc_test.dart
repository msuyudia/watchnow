import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_now_playing_movies.dart';
import 'package:watchnow/presentation/bloc/get_now_playing_movies_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late GetNowPlayingMoviesBloc getNowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    getNowPlayingMoviesBloc = GetNowPlayingMoviesBloc(mockGetNowPlayingMovies);
  });

  test('initial state should be empty', () {
    expect(getNowPlayingMoviesBloc.state, EmptyState());
  });

  blocTest<GetNowPlayingMoviesBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return getNowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(GetNowPlayingMoviesEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      MoviesHasDataState(testMovieList),
    ],
    verify: (bloc) => GetNowPlayingMoviesEvent().props,
  );

  blocTest<GetNowPlayingMoviesBloc, BlocState>(
    'Should emit [Loading, Error] when get now playing movies is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getNowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(GetNowPlayingMoviesEvent()),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetNowPlayingMoviesEvent().props,
  );
}
