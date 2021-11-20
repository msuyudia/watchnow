import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_season_detail.dart';
import 'package:watchnow/presentation/bloc/get_season_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_season_detail_bloc_test.mocks.dart';

@GenerateMocks([GetSeasonDetail])
void main() {
  late GetSeasonDetailBloc getSeasonDetailBloc;
  late MockGetSeasonDetail mockGetSeasonDetail;

  setUp(() {
    mockGetSeasonDetail = MockGetSeasonDetail();
    getSeasonDetailBloc = GetSeasonDetailBloc(mockGetSeasonDetail);
  });

  test('initial state should be empty', () {
    expect(getSeasonDetailBloc.state, EmptyState());
  });

  final tId = 1;
  final tSeasonNumber = 1;

  blocTest<GetSeasonDetailBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Right(testSeasonDetail));
      return getSeasonDetailBloc;
    },
    act: (bloc) => bloc.add(GetSeasonDetailEvent(tId, tSeasonNumber)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      SeasonDetailHasDataState(testSeasonDetail),
    ],
    verify: (bloc) => GetSeasonDetailEvent(tId, tSeasonNumber).props,
  );

  blocTest<GetSeasonDetailBloc, BlocState>(
    'Should emit [Loading, Error] when get season detail is unsuccessful',
    build: () {
      when(mockGetSeasonDetail.execute(tId, tSeasonNumber))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getSeasonDetailBloc;
    },
    act: (bloc) => bloc.add(GetSeasonDetailEvent(tId, tSeasonNumber)),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetSeasonDetailEvent(tId, tSeasonNumber).props,
  );
}
