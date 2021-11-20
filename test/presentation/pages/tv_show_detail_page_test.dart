import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_recommendations_bloc.dart';
import 'package:watchnow/presentation/bloc/watchlist_tv_show_status_bloc.dart';
import 'package:watchnow/presentation/pages/season_detail_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetTVShowDetailBloc extends MockBloc<BlocEvent, BlocState>
    implements GetTVShowDetailBloc {}

class MockWatchlistTVShowStatusBloc extends MockBloc<BlocEvent, BlocState>
    implements WatchlistTVShowStatusBloc {}

class MockGetTVShowRecommendationsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetTVShowRecommendationsBloc {}

void main() {
  late MockGetTVShowDetailBloc mockGetTVShowDetailBloc;
  late MockWatchlistTVShowStatusBloc mockWatchlistTVShowStatusBloc;
  late MockGetTVShowRecommendationsBloc mockGetTVShowRecommendationsBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetTVShowDetailBloc = MockGetTVShowDetailBloc();
    mockWatchlistTVShowStatusBloc = MockWatchlistTVShowStatusBloc();
    mockGetTVShowRecommendationsBloc = MockGetTVShowRecommendationsBloc();
  });

  final tvShowDetail = {TV_SHOW_ID: 1, SEASON_NUMBER: 1};

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetTVShowDetailBloc>.value(
          value: mockGetTVShowDetailBloc,
        ),
        BlocProvider<WatchlistTVShowStatusBloc>.value(
          value: mockWatchlistTVShowStatusBloc,
        ),
        BlocProvider<GetTVShowRecommendationsBloc>.value(
          value: mockGetTVShowRecommendationsBloc,
        ),
      ],
      child: MaterialApp(
          home: body,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case TVShowDetailPage.ROUTE_NAME:
                return MaterialPageRoute(
                  builder: (_) => TVShowDetailPage(id: 1),
                );
              case SeasonDetailPage.ROUTE_NAME:
                return MaterialPageRoute(
                  builder: (_) => SeasonDetailPage(tvShowDetail: tvShowDetail),
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

  void initTVShowDetail() async {
    whenListen(
      mockGetTVShowDetailBloc,
      Stream.fromIterable([
        TVShowDetailHasDataState(testTVShowDetail),
      ]),
      initialState: TVShowDetailHasDataState(testTVShowDetail),
    );
  }

  void watchlistButtonEmptyState() async {
    whenListen(
      mockWatchlistTVShowStatusBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  void tvShowRecommendationsEmptyState() async {
    whenListen(
      mockGetTVShowRecommendationsBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  group('All Tap Action For All Tappable Widgets', () {
    testWidgets('Page should can be tap item tv show recommendation',
        (WidgetTester tester) async {
      initTVShowDetail();
      watchlistButtonEmptyState();

      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(
        id: 1,
      )));
      await tester.tap(find.byKey(Key('tv_show_inkwell_0')));
    });

    testWidgets('Page should can be tap item season',
        (WidgetTester tester) async {
      initTVShowDetail();
      watchlistButtonEmptyState();

      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(
        id: 1,
      )));
      await tester.tap(find.byKey(Key('season_inkwell_0')));
    });
  });

  group('Show All States Get TV Show Detail', () {
    testWidgets('Page should display tv show detail empty state',
        (WidgetTester tester) async {
      whenListen(
        mockGetTVShowDetailBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetTVShowDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetTVShowDetailBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('tv_show_detail_container_empty')), findsOneWidget);
    });

    testWidgets('Page should display tv show detail loading',
        (WidgetTester tester) async {
      whenListen(
        mockGetTVShowDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTVShowDetailBloc.state, EmptyState());

      await expectLater(
        mockGetTVShowDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetTVShowDetailBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('tv_show_detail_center_loading')), findsOneWidget);
    });

    testWidgets('Page should display tv show detail error',
        (WidgetTester tester) async {
      whenListen(
        mockGetTVShowDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTVShowDetailBloc.state, EmptyState());

      await expectLater(
        mockGetTVShowDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetTVShowDetailBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('tv_show_detail_center_error')), findsOneWidget);
    });

    testWidgets('Page should display tv show detail content',
        (WidgetTester tester) async {
      watchlistButtonEmptyState();

      tvShowRecommendationsEmptyState();

      whenListen(
        mockGetTVShowDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowDetailHasDataState(testTVShowDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTVShowDetailBloc.state, EmptyState());

      await expectLater(
        mockGetTVShowDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowDetailHasDataState(testTVShowDetail),
        ]),
      );

      expect(mockGetTVShowDetailBloc.state,
          TVShowDetailHasDataState(testTVShowDetail));

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Page should can be tapped icon button',
        (WidgetTester tester) async {
      watchlistButtonEmptyState();

      tvShowRecommendationsEmptyState();

      whenListen(
        mockGetTVShowDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowDetailHasDataState(testTVShowDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTVShowDetailBloc.state, EmptyState());

      await expectLater(
        mockGetTVShowDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowDetailHasDataState(testTVShowDetail),
        ]),
      );

      expect(mockGetTVShowDetailBloc.state,
          TVShowDetailHasDataState(testTVShowDetail));

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      await tester.tap(find.byType(IconButton));
    });
  });

  group('Show All States Watchlist Button', () {
    testWidgets('Page should display watchlist button empty state',
        (WidgetTester tester) async {
      initTVShowDetail();
      tvShowRecommendationsEmptyState();

      whenListen(
        mockWatchlistTVShowStatusBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockWatchlistTVShowStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockWatchlistTVShowStatusBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('elevated_button_save')), findsOneWidget);
      expect(find.byKey(Key('icon_add')), findsOneWidget);
    });

    testWidgets('Page should display watchlist button loading state',
        (WidgetTester tester) async {
      initTVShowDetail();
      tvShowRecommendationsEmptyState();

      whenListen(
        mockWatchlistTVShowStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistTVShowStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistTVShowStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockWatchlistTVShowStatusBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('elevated_button_loading')), findsOneWidget);
    });

    testWidgets('Page should display icon check watchlist button when init',
        (WidgetTester tester) async {
      initTVShowDetail();
      tvShowRecommendationsEmptyState();

      whenListen(
        mockWatchlistTVShowStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          InitWatchlistButtonState(true),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistTVShowStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistTVShowStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          InitWatchlistButtonState(true),
        ]),
      );

      expect(
          mockWatchlistTVShowStatusBloc.state, InitWatchlistButtonState(true));

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('elevated_button_save')), findsOneWidget);
      expect(find.byKey(Key('icon_check')), findsOneWidget);
    });

    testWidgets('Page should display icon add watchlist button when init',
        (WidgetTester tester) async {
      initTVShowDetail();
      tvShowRecommendationsEmptyState();

      whenListen(
        mockWatchlistTVShowStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          InitWatchlistButtonState(false),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistTVShowStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistTVShowStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          InitWatchlistButtonState(false),
        ]),
      );

      expect(
          mockWatchlistTVShowStatusBloc.state, InitWatchlistButtonState(false));

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('elevated_button_save')), findsOneWidget);
      expect(find.byKey(Key('icon_add')), findsOneWidget);
    });

    testWidgets('Page should display icon check watchlist button after tap',
        (WidgetTester tester) async {
      initTVShowDetail();
      tvShowRecommendationsEmptyState();

      whenListen(
        mockWatchlistTVShowStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          WatchlistButtonState('Added to watchlist', true),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistTVShowStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistTVShowStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          WatchlistButtonState('Added to watchlist', true),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      await tester.tap(find.byKey(Key('elevated_button_save')));

      expect(
        mockWatchlistTVShowStatusBloc.state,
        WatchlistButtonState('Added to watchlist', true),
      );

      expect(find.byKey(Key('icon_check')), findsOneWidget);
    });

    testWidgets('Page should display icon add watchlist button after tap',
        (WidgetTester tester) async {
      initTVShowDetail();
      tvShowRecommendationsEmptyState();

      whenListen(
        mockWatchlistTVShowStatusBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          WatchlistButtonState('Removed from watchlist', false),
        ]),
        initialState: EmptyState(),
      );

      expect(mockWatchlistTVShowStatusBloc.state, EmptyState());

      await expectLater(
        mockWatchlistTVShowStatusBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          WatchlistButtonState('Removed from watchlist', false),
        ]),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      await tester.tap(find.byKey(Key('elevated_button_save')));

      expect(
        mockWatchlistTVShowStatusBloc.state,
        WatchlistButtonState('Removed from watchlist', false),
      );

      expect(find.byKey(Key('icon_add')), findsOneWidget);
    });
  });

  group('Show All States TV Show Recommendations', () {
    testWidgets('Page should display tv show recommendations empty state',
        (WidgetTester tester) async {
      initTVShowDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetTVShowRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetTVShowRecommendationsBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('tv_show_recommendations_container_empty')),
          findsOneWidget);
    });

    testWidgets('Page should display tv show recommendations loading state',
        (WidgetTester tester) async {
      initTVShowDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetTVShowRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetTVShowRecommendationsBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(find.byKey(Key('tv_show_recommendations_center_loading')),
          findsOneWidget);
    });

    testWidgets('Page should display tv show recommendations is empty',
        (WidgetTester tester) async {
      initTVShowDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetTVShowRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
      );

      expect(
        mockGetTVShowRecommendationsBloc.state,
        TVShowsHasDataState(<TVShow>[]),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(
        find.byKey(Key('tv_show_recommendations_center_empty')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display tv show recommendations has data state',
        (WidgetTester tester) async {
      initTVShowDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetTVShowRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(
        mockGetTVShowRecommendationsBloc.state,
        TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(
        find.byKey(Key('tv_show_recommendations_container')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display tv show recommendations error state',
        (WidgetTester tester) async {
      initTVShowDetail();

      watchlistButtonEmptyState();

      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetTVShowRecommendationsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(
        mockGetTVShowRecommendationsBloc.state,
        ErrorState('Error message'),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowDetailPage(id: 1)));

      expect(
        find.byKey(Key('tv_show_recommendations_center_error')),
        findsOneWidget,
      );
    });
  });
}
