import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_watchlist_movies.dart';
import 'package:watchnow/presentation/bloc/get_watchlist_movies_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_watchlist_movies_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late GetWatchlistMoviesBloc getWatchlistMoviesBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    getWatchlistMoviesBloc = GetWatchlistMoviesBloc(mockGetWatchlistMovies);
  });

  test('initial state should be empty', () {
    expect(getWatchlistMoviesBloc.state, EmptyState());
  });

  blocTest<GetWatchlistMoviesBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return getWatchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistMoviesEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      MoviesHasDataState(testMovieList),
    ],
    verify: (bloc) => GetWatchlistMoviesEvent().props,
  );

  blocTest<GetWatchlistMoviesBloc, BlocState>(
    'Should emit [Loading, Error] when get watchlist movies is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getWatchlistMoviesBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistMoviesEvent()),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetWatchlistMoviesEvent().props,
  );
}
