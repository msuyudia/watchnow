import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_popular_tv_shows.dart';
import 'package:watchnow/presentation/bloc/get_popular_tv_shows_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_popular_tv_shows_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTVShows])
void main() {
  late GetPopularTVShowsBloc getPopularTVShowsBloc;
  late MockGetPopularTVShows mockGetPopularTVShows;

  setUp(() {
    mockGetPopularTVShows = MockGetPopularTVShows();
    getPopularTVShowsBloc = GetPopularTVShowsBloc(mockGetPopularTVShows);
  });

  test('initial state should be empty', () {
    expect(getPopularTVShowsBloc.state, EmptyState());
  });

  blocTest<GetPopularTVShowsBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      return getPopularTVShowsBloc;
    },
    act: (bloc) => bloc.add(GetPopularTVShowsEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      TVShowsHasDataState(testTVShowList),
    ],
    verify: (bloc) => GetPopularTVShowsEvent().props,
  );

  blocTest<GetPopularTVShowsBloc, BlocState>(
    'Should emit [Loading, Error] when get popular tv shows is unsuccessful',
    build: () {
      when(mockGetPopularTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getPopularTVShowsBloc;
    },
    act: (bloc) => bloc.add(GetPopularTVShowsEvent()),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetPopularTVShowsEvent().props,
  );
}
