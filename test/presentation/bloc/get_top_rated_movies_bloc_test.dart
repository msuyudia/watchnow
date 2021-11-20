import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/failure.dart';
import 'package:watchnow/domain/usecases/get_top_rated_movies.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_movies_bloc.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_top_rated_movies_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late GetTopRatedMoviesBloc getTopRatedMoviesBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    getTopRatedMoviesBloc = GetTopRatedMoviesBloc(mockGetTopRatedMovies);
  });

  test('initial state should be empty', () {
    expect(getTopRatedMoviesBloc.state, EmptyState());
  });

  blocTest<GetTopRatedMoviesBloc, BlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return getTopRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(GetTopRatedMoviesEvent()),
    wait: const Duration(milliseconds: 100),
    expect: () => [
      LoadingState(),
      MoviesHasDataState(testMovieList),
    ],
    verify: (bloc) => GetTopRatedMoviesEvent().props,
  );

  blocTest<GetTopRatedMoviesBloc, BlocState>(
    'Should emit [Loading, Error] when get top rated movies is unsuccessful',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getTopRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(GetTopRatedMoviesEvent()),
    expect: () => [
      LoadingState(),
      ErrorState('Server Failure'),
    ],
    verify: (bloc) => GetTopRatedMoviesEvent().props,
  );
}
