import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_movie_detail.dart';
import 'package:watchnow/presentation/bloc/get_movie_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_movie_detail_bloc_test.mocks.dart';

@GenerateMocks([GetMovieDetail])
void main() {
  late GetMovieDetailBloc getMovieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    getMovieDetailBloc = GetMovieDetailBloc(mockGetMovieDetail);
  });

  test('initial state should be empty', () {
    expect(getMovieDetailBloc.state, EmptyState());
  });

  final tId = 1;

  blocTest<GetMovieDetailBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      return getMovieDetailBloc;
    },
    act: (bloc) => bloc.add(GetMovieDetailEvent(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      MovieDetailHasDataState(testMovieDetail),
    ],
    verify: (bloc) => GetMovieDetailEvent(tId).props,
  );

  blocTest<GetMovieDetailBloc, BlocState>(
    'Should emit [Loading, Error] when get movie detail is unsuccessful',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getMovieDetailBloc;
    },
    act: (bloc) => bloc.add(GetMovieDetailEvent(tId)),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetMovieDetailEvent(tId).props,
  );
}
