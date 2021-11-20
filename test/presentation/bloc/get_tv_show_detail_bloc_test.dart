import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_tv_show_detail.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_tv_show_detail_bloc_test.mocks.dart';

@GenerateMocks([GetTVShowDetail])
void main() {
  late GetTVShowDetailBloc getTVShowDetailBloc;
  late MockGetTVShowDetail mockGetTVShowDetail;

  setUp(() {
    mockGetTVShowDetail = MockGetTVShowDetail();
    getTVShowDetailBloc = GetTVShowDetailBloc(mockGetTVShowDetail);
  });

  test('initial state should be empty', () {
    expect(getTVShowDetailBloc.state, EmptyState());
  });

  final tId = 1;

  blocTest<GetTVShowDetailBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVShowDetail));
      return getTVShowDetailBloc;
    },
    act: (bloc) => bloc.add(GetTVShowDetailEvent(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      TVShowDetailHasDataState(testTVShowDetail),
    ],
    verify: (bloc) => GetTVShowDetailEvent(tId).props,
  );

  blocTest<GetTVShowDetailBloc, BlocState>(
    'Should emit [Loading, Error] when get tv show detail is unsuccessful',
    build: () {
      when(mockGetTVShowDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getTVShowDetailBloc;
    },
    act: (bloc) => bloc.add(GetTVShowDetailEvent(tId)),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetTVShowDetailEvent(tId).props,
  );
}
