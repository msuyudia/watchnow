import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/presentation/bloc/get_popular_movies_bloc.dart';
import 'package:watchnow/presentation/pages/movie_detail_page.dart';
import 'package:watchnow/presentation/pages/popular_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetPopularMoviesBloc extends MockBloc<BlocEvent, BlocState>
    implements GetPopularMoviesBloc {}

void main() {
  late MockGetPopularMoviesBloc mockGetPopularMoviesBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetPopularMoviesBloc = MockGetPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetPopularMoviesBloc>.value(
      value: mockGetPopularMoviesBloc,
      child: MaterialApp(
          home: body,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case MovieDetailPage.ROUTE_NAME:
                return MaterialPageRoute(
                  builder: (_) => MovieDetailPage(id: 1),
                );
              default:
                return MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                });
            }
          }),
    );
  }

  testWidgets('Page should can be tap item movie', (WidgetTester tester) async {
    whenListen(
      mockGetPopularMoviesBloc,
      Stream.fromIterable([
        MoviesHasDataState(testMovieList),
      ]),
      initialState: MoviesHasDataState(testMovieList),
    );

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Popular Movies Page', () {
    testWidgets('Page should display loading', (WidgetTester tester) async {
      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetPopularMoviesBloc.state, LoadingState());

      final center = find.byType(Center);
      final loading = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      expect(center, findsOneWidget);
      expect(loading, findsOneWidget);
    });

    testWidgets('Page should display popular movies empty',
        (WidgetTester tester) async {
      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
      );

      expect(mockGetPopularMoviesBloc.state, MoviesHasDataState(<Movie>[]));

      final centerEmpty = find.byKey(Key('center_empty'));

      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      expect(centerEmpty, findsOneWidget);
    });

    testWidgets('Page should display popular movies',
        (WidgetTester tester) async {
      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(testMovieList),
        ]),
      );

      expect(mockGetPopularMoviesBloc.state, MoviesHasDataState(testMovieList));

      final listView = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      expect(listView, findsOneWidget);
    });

    testWidgets('Page should display error', (WidgetTester tester) async {
      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetPopularMoviesBloc.state, ErrorState('Error message'));

      final centerError = find.byKey(Key('center_error'));

      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      expect(centerError, findsOneWidget);
    });

    testWidgets('Page should display empty', (WidgetTester tester) async {
      whenListen(
        mockGetPopularMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetPopularMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetPopularMoviesBloc.state, EmptyState());

      final container = find.byType(Container);

      await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

      expect(container, findsOneWidget);
    });
  });
}
