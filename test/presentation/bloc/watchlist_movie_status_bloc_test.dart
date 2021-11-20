import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_watchlist_movie_status.dart';
import 'package:watchnow/domain/usecases/remove_watchlist_movie.dart';
import 'package:watchnow/domain/usecases/save_watchlist_movie.dart';
import 'package:watchnow/presentation/bloc/watchlist_movie_status_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_movie_status_bloc_test.mocks.dart';

@GenerateMocks(
    [GetWatchListMovieStatus, SaveWatchlistMovie, RemoveWatchlistMovie])
void main() {
  late WatchlistMovieStatusBloc watchlistMovieStatusBloc;
  late MockGetWatchListMovieStatus mockGetWatchListMovieStatus;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetWatchListMovieStatus = MockGetWatchListMovieStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    watchlistMovieStatusBloc = WatchlistMovieStatusBloc(
        mockGetWatchListMovieStatus,
        mockSaveWatchlistMovie,
        mockRemoveWatchlistMovie);
  });

  test('initial state should be empty', () {
    expect(watchlistMovieStatusBloc.state, EmptyState());
  });

  final tId = 1;

  blocTest<WatchlistMovieStatusBloc, BlocState>(
    'Should emit [Loading, InitWatchlistButtonState] when watchlist is already saved',
    build: () {
      when(mockGetWatchListMovieStatus.execute(tId))
          .thenAnswer((_) async => true);
      return watchlistMovieStatusBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistMovieStatusEvent(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      InitWatchlistButtonState(true),
    ],
    verify: (bloc) => GetWatchlistMovieStatusEvent(tId).props,
  );

  blocTest<WatchlistMovieStatusBloc, BlocState>(
    'Should emit [Loading, InitWatchlistButtonState] when watchlist is not saved',
    build: () {
      when(mockGetWatchListMovieStatus.execute(tId))
          .thenAnswer((_) async => false);
      return watchlistMovieStatusBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistMovieStatusEvent(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      InitWatchlistButtonState(false),
    ],
    verify: (bloc) => GetWatchlistMovieStatusEvent(tId).props,
  );

  blocTest<WatchlistMovieStatusBloc, BlocState>(
    'Should emit [Loading, WatchlistButtonState] when save to watchlist successfully',
    build: () {
      when(mockSaveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      return watchlistMovieStatusBloc;
    },
    act: (bloc) => bloc.add(SaveWatchlistMovieStatusEvent(testMovieDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      WatchlistButtonState('Added to Watchlist', true),
    ],
    verify: (bloc) => SaveWatchlistMovieStatusEvent(testMovieDetail).props,
  );

  blocTest<WatchlistMovieStatusBloc, BlocState>(
    'Should emit [Loading, Error] when save to watchlist unsuccessfully',
    build: () {
      when(mockSaveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return watchlistMovieStatusBloc;
    },
    act: (bloc) => bloc.add(SaveWatchlistMovieStatusEvent(testMovieDetail)),
    expect: () => [
      LoadingState(),
      WatchlistButtonState('Failed', false),
    ],
    verify: (bloc) => SaveWatchlistMovieStatusEvent(testMovieDetail).props,
  );

  blocTest<WatchlistMovieStatusBloc, BlocState>(
    'Should emit [Loading, WatchlistButtonState] when remove from watchlist successfully',
    build: () {
      when(mockRemoveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      return watchlistMovieStatusBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistMovieStatusEvent(testMovieDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      WatchlistButtonState('Removed from Watchlist', false),
    ],
    verify: (bloc) => RemoveWatchlistMovieStatusEvent(testMovieDetail).props,
  );

  blocTest<WatchlistMovieStatusBloc, BlocState>(
    'Should emit [Loading, Error] when remove from watchlist unsuccessfully',
    build: () {
      when(mockRemoveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return watchlistMovieStatusBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistMovieStatusEvent(testMovieDetail)),
    expect: () => [
      LoadingState(),
      WatchlistButtonState('Failed', true),
    ],
    verify: (bloc) => RemoveWatchlistMovieStatusEvent(testMovieDetail).props,
  );
}
