import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/get_watchlist_tv_shows_bloc.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';
import 'package:watchnow/presentation/pages/watchlist_tv_shows_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetWatchlistTVShowsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetWatchlistTVShowsBloc {}

void main() {
  late MockGetWatchlistTVShowsBloc mockGetWatchlistTVShowsBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetWatchlistTVShowsBloc = MockGetWatchlistTVShowsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetWatchlistTVShowsBloc>.value(
      value: mockGetWatchlistTVShowsBloc,
      child: MaterialApp(
          home: body,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case TVShowDetailPage.ROUTE_NAME:
                return MaterialPageRoute(
                  builder: (_) => TVShowDetailPage(id: 1),
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

  testWidgets('Page should can be tap item tv show',
      (WidgetTester tester) async {
    whenListen(
      mockGetWatchlistTVShowsBloc,
      Stream.fromIterable([
        TVShowsHasDataState(testTVShowList),
      ]),
      initialState: TVShowsHasDataState(testTVShowList),
    );

    await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));
    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Watchlist TV Shows Page', () {
    testWidgets('Page should display loading', (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetWatchlistTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetWatchlistTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetWatchlistTVShowsBloc.state, LoadingState());

      final center = find.byType(Center);
      final loading = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(center, findsOneWidget);
      expect(loading, findsOneWidget);
    });

    testWidgets('Page should display popular tv shows empty',
        (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetWatchlistTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetWatchlistTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
      );

      expect(
          mockGetWatchlistTVShowsBloc.state, TVShowsHasDataState(<TVShow>[]));

      final centerEmpty = find.byKey(Key('center_empty'));

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(centerEmpty, findsOneWidget);
    });

    testWidgets('Page should display popular tv shows',
        (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetWatchlistTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetWatchlistTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(mockGetWatchlistTVShowsBloc.state,
          TVShowsHasDataState(testTVShowList));

      final listView = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(listView, findsOneWidget);
    });

    testWidgets('Page should display error', (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetWatchlistTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetWatchlistTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetWatchlistTVShowsBloc.state, ErrorState('Error message'));

      final centerError = find.byKey(Key('center_error'));

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(centerError, findsOneWidget);
    });

    testWidgets('Page should display empty', (WidgetTester tester) async {
      whenListen(
        mockGetWatchlistTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetWatchlistTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetWatchlistTVShowsBloc.state, EmptyState());

      final container = find.byType(Container);

      await tester.pumpWidget(_makeTestableWidget(WatchlistTVShowsPage()));

      expect(container, findsOneWidget);
    });
  });
}
