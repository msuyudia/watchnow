import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_watchlist_tv_show_status.dart';
import 'package:watchnow/domain/usecases/remove_watchlist_tv_show.dart';
import 'package:watchnow/domain/usecases/save_watchlist_tv_show.dart';
import 'package:watchnow/presentation/bloc/watchlist_tv_show_status_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_tv_show_status_bloc_test.mocks.dart';

@GenerateMocks(
    [GetWatchListTVShowStatus, SaveWatchlistTVShow, RemoveWatchlistTVShow])
void main() {
  late WatchlistTVShowStatusBloc watchlistTVShowStatusBloc;
  late MockGetWatchListTVShowStatus mockGetWatchListTVShowStatus;
  late MockSaveWatchlistTVShow mockSaveWatchlistTVShow;
  late MockRemoveWatchlistTVShow mockRemoveWatchlistTVShow;

  setUp(() {
    mockGetWatchListTVShowStatus = MockGetWatchListTVShowStatus();
    mockSaveWatchlistTVShow = MockSaveWatchlistTVShow();
    mockRemoveWatchlistTVShow = MockRemoveWatchlistTVShow();
    watchlistTVShowStatusBloc = WatchlistTVShowStatusBloc(
        mockGetWatchListTVShowStatus,
        mockSaveWatchlistTVShow,
        mockRemoveWatchlistTVShow);
  });

  test('initial state should be empty', () {
    expect(watchlistTVShowStatusBloc.state, EmptyState());
  });

  final tId = 1;

  blocTest<WatchlistTVShowStatusBloc, BlocState>(
    'Should emit [Loading, InitWatchlistButtonState] when watchlist is saved',
    build: () {
      when(mockGetWatchListTVShowStatus.execute(tId))
          .thenAnswer((_) async => true);
      return watchlistTVShowStatusBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistTVShowStatusEvent(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      InitWatchlistButtonState(true),
    ],
    verify: (bloc) => GetWatchlistTVShowStatusEvent(tId).props,
  );

  blocTest<WatchlistTVShowStatusBloc, BlocState>(
    'Should emit [Loading, InitWatchlistButtonState] when watchlist is not saved',
    build: () {
      when(mockGetWatchListTVShowStatus.execute(tId))
          .thenAnswer((_) async => false);
      return watchlistTVShowStatusBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistTVShowStatusEvent(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      InitWatchlistButtonState(false),
    ],
    verify: (bloc) => GetWatchlistTVShowStatusEvent(tId).props,

  );

  blocTest<WatchlistTVShowStatusBloc, BlocState>(
    'Should emit [Loading, WatchlistButtonState] when save to watchlist successfully',
    build: () {
      when(mockSaveWatchlistTVShow.execute(testTVShowDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      return watchlistTVShowStatusBloc;
    },
    act: (bloc) => bloc.add(SaveWatchlistTVShowStatusEvent(testTVShowDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      WatchlistButtonState('Added to Watchlist', true),
    ],
    verify: (bloc) => SaveWatchlistTVShowStatusEvent(testTVShowDetail).props,
  );

  blocTest<WatchlistTVShowStatusBloc, BlocState>(
    'Should emit [Loading, Error] when save to watchlist unsuccessfully',
    build: () {
      when(mockSaveWatchlistTVShow.execute(testTVShowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return watchlistTVShowStatusBloc;
    },
    act: (bloc) => bloc.add(SaveWatchlistTVShowStatusEvent(testTVShowDetail)),
    expect: () => [
      LoadingState(),
      WatchlistButtonState('Failed', false),
    ],
    verify: (bloc) => SaveWatchlistTVShowStatusEvent(testTVShowDetail).props,
  );

  blocTest<WatchlistTVShowStatusBloc, BlocState>(
    'Should emit [Loading, WatchlistButtonState] when remove from watchlist successfully',
    build: () {
      when(mockRemoveWatchlistTVShow.execute(testTVShowDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      return watchlistTVShowStatusBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistTVShowStatusEvent(testTVShowDetail)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      WatchlistButtonState('Removed from Watchlist', false),
    ],
    verify: (bloc) => RemoveWatchlistTVShowStatusEvent(testTVShowDetail).props,
  );

  blocTest<WatchlistTVShowStatusBloc, BlocState>(
    'Should emit [Loading, Error] when remove from watchlist unsuccessfully',
    build: () {
      when(mockRemoveWatchlistTVShow.execute(testTVShowDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      return watchlistTVShowStatusBloc;
    },
    act: (bloc) => bloc.add(RemoveWatchlistTVShowStatusEvent(testTVShowDetail)),
    expect: () => [
      LoadingState(),
      WatchlistButtonState('Failed', true),
    ],
    verify: (bloc) => RemoveWatchlistTVShowStatusEvent(testTVShowDetail).props,
  );
}
