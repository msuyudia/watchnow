import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/search_tv_shows.dart';
import 'package:watchnow/presentation/bloc/search_tv_show_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'search_tv_show_bloc_test.mocks.dart';

@GenerateMocks([SearchTVShows])
void main() {
  late SearchTVShowBloc searchBloc;
  late MockSearchTVShows mockSearchTVShows;

  setUp(() {
    mockSearchTVShows = MockSearchTVShows();
    searchBloc = SearchTVShowBloc(mockSearchTVShows);
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, EmptyState());
  });

  final tQuery = 'gotham';

  blocTest<SearchTVShowBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Right(testTVShowList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(SearchTVShowEvent(tQuery)),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      TVShowsHasDataState(testTVShowList),
    ],
    verify: (bloc) => SearchTVShowEvent(tQuery).props,
  );

  blocTest<SearchTVShowBloc, BlocState>(
    'Should emit [Loading, Error] when get search tv show is unsuccessful',
    build: () {
      when(mockSearchTVShows.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(SearchTVShowEvent(tQuery)),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => SearchTVShowEvent(tQuery).props,
  );
}
