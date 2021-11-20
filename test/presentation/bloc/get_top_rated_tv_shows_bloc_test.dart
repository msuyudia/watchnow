import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_top_rated_tv_shows.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_tv_shows_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_top_rated_tv_shows_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTVShows])
void main() {
  late GetTopRatedTVShowsBloc getTopRatedTVShowsBloc;
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;

  setUp(() {
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    getTopRatedTVShowsBloc = GetTopRatedTVShowsBloc(mockGetTopRatedTVShows);
  });

  test('initial state should be empty', () {
    expect(getTopRatedTVShowsBloc.state, EmptyState());
  });

  blocTest<GetTopRatedTVShowsBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      return getTopRatedTVShowsBloc;
    },
    act: (bloc) => bloc.add(GetTopRatedTVShowsEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      TVShowsHasDataState(testTVShowList),
    ],
    verify: (bloc) => GetTopRatedTVShowsEvent().props,
  );

  blocTest<GetTopRatedTVShowsBloc, BlocState>(
    'Should emit [Loading, Error] when get top rated tv shows is unsuccessful',
    build: () {
      when(mockGetTopRatedTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getTopRatedTVShowsBloc;
    },
    act: (bloc) => bloc.add(GetTopRatedTVShowsEvent()),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetTopRatedTVShowsEvent().props,
  );
}
