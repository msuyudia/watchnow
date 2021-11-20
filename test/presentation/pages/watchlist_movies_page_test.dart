import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/movie.dart';
import 'package:watchnow/presentation/bloc/get_watchlist_movies_bloc.dart';
import 'package:watchnow/presentation/pages/movie_detail_page.dart';
import 'package:watchnow/presentation/pages/watchlist_movies_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetWatchlistMoviesBloc extends MockBloc<BlocEvent, BlocState>
    implements GetWatchlistMoviesBloc {}

void main() {
  late MockGetWatchlistMoviesBloc mockGetWatchlistMoviesBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetWatchlistMoviesBloc = MockGetWatchlistMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetWatchlistMoviesBloc>.value(
      value: mockGetWatchlistMoviesBloc,
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
      mockGetWatchlistMoviesBloc,
      Stream.fromIterable([
        MoviesHasDataState(testMovieList),
      ]),
      initialState: MoviesHasDataState(testMovieList),
    );

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));
    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Watchlist Movies Page', () {
    testWidgets('Page should display loading', (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetWatchlistMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetWatchlistMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetWatchlistMoviesBloc.state, LoadingState());

      final center = find.byType(Center);
      final loading = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      expect(center, findsOneWidget);
      expect(loading, findsOneWidget);
    });

    testWidgets('Page should display top rated movies empty',
        (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetWatchlistMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetWatchlistMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
      );
    });

    testWidgets('Page should display top rated movies',
        (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetWatchlistMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetWatchlistMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          MoviesHasDataState(<Movie>[]),
        ]),
      );

      expect(mockGetWatchlistMoviesBloc.state, MoviesHasDataState(<Movie>[]));

      final centerEmpty = find.byKey(Key('center_empty'));

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      expect(centerEmpty, findsOneWidget);
    });

    testWidgets('Page should display error', (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetWatchlistMoviesBloc.state, EmptyState());

      await expectLater(
        mockGetWatchlistMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetWatchlistMoviesBloc.state, ErrorState('Error message'));

      final centerError = find.byKey(Key('center_error'));

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      expect(centerError, findsOneWidget);
    });

    testWidgets('Page should display empty', (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistMoviesBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetWatchlistMoviesBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetWatchlistMoviesBloc.state, EmptyState());

      final container = find.byType(Container);

      await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

      expect(container, findsOneWidget);
    });
  });
}
