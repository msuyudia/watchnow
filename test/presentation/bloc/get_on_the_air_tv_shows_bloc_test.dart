import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_on_the_air_tv_shows.dart';
import 'package:watchnow/presentation/bloc/get_on_the_air_tv_shows_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_on_the_air_tv_shows_bloc_test.mocks.dart';

@GenerateMocks([GetOnTheAirTVShows])
void main() {
  late GetOnTheAirTVShowsBloc getOnTheAirTVShowsBloc;
  late MockGetOnTheAirTVShows mockGetOnTheAirTVShows;

  setUp(() {
    mockGetOnTheAirTVShows = MockGetOnTheAirTVShows();
    getOnTheAirTVShowsBloc = GetOnTheAirTVShowsBloc(mockGetOnTheAirTVShows);
  });

  test('initial state should be empty', () {
    expect(getOnTheAirTVShowsBloc.state, EmptyState());
  });

  blocTest<GetOnTheAirTVShowsBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Right(testTVShowList));
      return getOnTheAirTVShowsBloc;
    },
    act: (bloc) => bloc.add(GetOnTheAirTVShowsEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      TVShowsHasDataState(testTVShowList),
    ],
    verify: (bloc) => GetOnTheAirTVShowsEvent().props,
  );

  blocTest<GetOnTheAirTVShowsBloc, BlocState>(
    'Should emit [Loading, Error] when get on the air tv shows is unsuccessful',
    build: () {
      when(mockGetOnTheAirTVShows.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getOnTheAirTVShowsBloc;
    },
    act: (bloc) => bloc.add(GetOnTheAirTVShowsEvent()),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetOnTheAirTVShowsEvent().props,
  );
}
