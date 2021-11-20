import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_episode_detail.dart';
import 'package:watchnow/presentation/bloc/get_episode_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_episode_detail_bloc_test.mocks.dart';

@GenerateMocks([GetEpisodeDetail])
void main() {
  late GetEpisodeDetailBloc getEpisodeDetailBloc;
  late MockGetEpisodeDetail mockGetEpisodeDetail;

  setUp(() {
    mockGetEpisodeDetail = MockGetEpisodeDetail();
    getEpisodeDetailBloc = GetEpisodeDetailBloc(mockGetEpisodeDetail);
  });

  test('initial state should be empty', () {
    expect(getEpisodeDetailBloc.state, EmptyState());
  });

  final tId = 1;
  final tSeasonNumber = 1;
  final tEpisodeNumber = 1;

  blocTest<GetEpisodeDetailBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetEpisodeDetail.execute(tId, tSeasonNumber, tEpisodeNumber))
          .thenAnswer((_) async => Right(testEpisodeDetail));
      return getEpisodeDetailBloc;
    },
    act: (bloc) =>
        bloc.add(GetEpisodeDetailEvent(tId, tSeasonNumber, tEpisodeNumber)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      EpisodeDetailHasDataState(testEpisodeDetail),
    ],
    verify: (bloc) =>
        GetEpisodeDetailEvent(tId, tSeasonNumber, tEpisodeNumber).props,
  );

  blocTest<GetEpisodeDetailBloc, BlocState>(
    'Should emit [Loading, Error] when get episode detail is unsuccessful',
    build: () {
      when(mockGetEpisodeDetail.execute(tId, tSeasonNumber, tEpisodeNumber))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getEpisodeDetailBloc;
    },
    act: (bloc) =>
        bloc.add(GetEpisodeDetailEvent(tId, tSeasonNumber, tEpisodeNumber)),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) =>
        GetEpisodeDetailEvent(tId, tSeasonNumber, tEpisodeNumber).props,
  );
}
