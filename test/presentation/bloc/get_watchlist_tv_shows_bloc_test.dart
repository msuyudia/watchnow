import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_watchlist_tv_shows.dart';
import 'package:watchnow/presentation/bloc/get_watchlist_tv_shows_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_watchlist_tv_shows_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTVShows])
void main() {
  late GetWatchlistTVShowsBloc getWatchlistTVShowsBloc;
  late MockGetWatchlistTVShows mockGetWatchlistTVShows;

  setUp(() {
    mockGetWatchlistTVShows = MockGetWatchlistTVShows();
    getWatchlistTVShowsBloc = GetWatchlistTVShowsBloc(mockGetWatchlistTVShows);
  });

  test('initial state should be empty', () {
    expect(getWatchlistTVShowsBloc.state, EmptyState());
  });

  blocTest<GetWatchlistTVShowsBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      return getWatchlistTVShowsBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistTVShowsEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      TVShowsHasDataState(testTVShowList),
    ],
    verify: (bloc) => GetWatchlistTVShowsEvent().props,
  );

  blocTest<GetWatchlistTVShowsBloc, BlocState>(
    'Should emit [Loading, Error] when get watchlist tv shows is unsuccessful',
    build: () {
      when(mockGetWatchlistTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getWatchlistTVShowsBloc;
    },
    act: (bloc) => bloc.add(GetWatchlistTVShowsEvent()),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetWatchlistTVShowsEvent().props,
  );
}
