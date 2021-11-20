import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_tv_show_recommendations.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_recommendations_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_tv_show_recommendations_bloc_test.mocks.dart';

@GenerateMocks([GetTVShowRecommendations])
void main() {
  late GetTVShowRecommendationsBloc getTVShowRecommendationsBloc;
  late MockGetTVShowRecommendations mockGetTVShowRecommendations;

  setUp(() {
    mockGetTVShowRecommendations = MockGetTVShowRecommendations();
    getTVShowRecommendationsBloc =
        GetTVShowRecommendationsBloc(mockGetTVShowRecommendations);
  });

  test('initial state should be empty', () {
    expect(getTVShowRecommendationsBloc.state, EmptyState());
  });

  final tId = 1;

  blocTest<GetTVShowRecommendationsBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Right(testTVShowList));
      return getTVShowRecommendationsBloc;
    },
    act: (bloc) => bloc.add(GetTVShowRecommendationsEvent(tId)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      TVShowsHasDataState(testTVShowList),
    ],
    verify: (bloc) => GetTVShowRecommendationsEvent(tId).props,
  );

  blocTest<GetTVShowRecommendationsBloc, BlocState>(
    'Should emit [Loading, Error] when get tv show recommendations is unsuccessful',
    build: () {
      when(mockGetTVShowRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getTVShowRecommendationsBloc;
    },
    act: (bloc) => bloc.add(GetTVShowRecommendationsEvent(tId)),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetTVShowRecommendationsEvent(tId).props,
  );
}
