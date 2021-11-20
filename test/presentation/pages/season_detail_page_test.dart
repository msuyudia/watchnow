import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/domain/entities/season_detail.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/get_season_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_recommendations_bloc.dart';
import 'package:watchnow/presentation/pages/episode_detail_page.dart';
import 'package:watchnow/presentation/pages/season_detail_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetSeasonDetailBloc extends MockBloc<BlocEvent, BlocState>
    implements GetSeasonDetailBloc {}

class MockGetTVShowRecommendationsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetTVShowRecommendationsBloc {}

void main() {
  late MockGetSeasonDetailBloc mockGetSeasonDetailBloc;
  late MockGetTVShowRecommendationsBloc mockGetTVShowRecommendationsBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetSeasonDetailBloc = MockGetSeasonDetailBloc();
    mockGetTVShowRecommendationsBloc = MockGetTVShowRecommendationsBloc();
  });

  final tvShowDetail = {TV_SHOW_ID: 1, SEASON_NUMBER: 1};
  final seasonDetail = {TV_SHOW_ID: 1, SEASON_NUMBER: 1, EPISODE_NUMBER: 1};

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetSeasonDetailBloc>.value(
          value: mockGetSeasonDetailBloc,
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
              case EpisodeDetailPage.ROUTE_NAME:
                return MaterialPageRoute(
                  builder: (_) => EpisodeDetailPage(seasonDetail: seasonDetail),
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

  void initSeasonDetail() async {
    whenListen(
      mockGetSeasonDetailBloc,
      Stream.fromIterable([
        SeasonDetailHasDataState(testSeasonDetail),
      ]),
      initialState: SeasonDetailHasDataState(testSeasonDetail),
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
      initSeasonDetail();
      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(SeasonDetailPage(
        tvShowDetail: tvShowDetail,
      )));
      await tester.tap(find.byKey(Key('tv_show_inkwell_0')));
    });

    testWidgets('Page should can be tap item episode',
        (WidgetTester tester) async {
      initSeasonDetail();
      whenListen(
        mockGetTVShowRecommendationsBloc,
        Stream.fromIterable([
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(SeasonDetailPage(
        tvShowDetail: tvShowDetail,
      )));
      await tester.tap(find.byKey(Key('episode_inkwell_0')));
    });
  });

  group('Show All States Get Season Detail', () {
    testWidgets('Page should display season detail empty state',
        (WidgetTester tester) async {
      whenListen(
        mockGetSeasonDetailBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetSeasonDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetSeasonDetailBloc.state, EmptyState());

      await tester.pumpWidget(
        _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)),
      );

      expect(find.byKey(Key('season_detail_container_empty')), findsOneWidget);
    });

    testWidgets('Page should display season detail loading',
        (WidgetTester tester) async {
      whenListen(
        mockGetSeasonDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetSeasonDetailBloc.state, EmptyState());

      await expectLater(
        mockGetSeasonDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetSeasonDetailBloc.state, LoadingState());

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(find.byKey(Key('season_detail_center_loading')), findsOneWidget);
    });

    testWidgets('Page should display season detail error',
        (WidgetTester tester) async {
      whenListen(
        mockGetSeasonDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetSeasonDetailBloc.state, EmptyState());

      await expectLater(
        mockGetSeasonDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetSeasonDetailBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(find.byKey(Key('season_detail_center_error')), findsOneWidget);
    });

    testWidgets('Page should display season detail content with episodes empty',
        (WidgetTester tester) async {
      final tSeasonDetail = SeasonDetail(
        posterPath: '/ggEVcCvtCcfSgYIeVubCBJXse7X.jpg',
        name: 'Season 1',
        overview:
            "A new recruit in Captain Sarah Essen's Gotham City Police Department, Detective James Gordon is paired with Harvey Bullock to solve one of Gotham's highest-profile cases: the murder of Thomas and Martha Wayne. During his investigation, Gordon meets the Waynes' son Bruce, now in the care of his butler Alfred Pennyworth, which further compels Gordon to catch the mysterious killer. Along the way, Gordon must confront mobstress Fish Mooney, mafia led by Carmine Falcone, as well as many of Gotham's future villains such as Selina Kyle, Edward Nygma, and Oswald Cobblepot. Eventually, Gordon is forced to form an unlikely friendship with Wayne, one that will help shape the boy's future in his destiny of becoming a crusader.",
        episodes: [],
        seasonNumber: 1,
      );
      tvShowRecommendationsEmptyState();

      whenListen(
        mockGetSeasonDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          SeasonDetailHasDataState(tSeasonDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetSeasonDetailBloc.state, EmptyState());

      await expectLater(
        mockGetSeasonDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          SeasonDetailHasDataState(tSeasonDetail),
        ]),
      );

      expect(mockGetSeasonDetailBloc.state,
          SeasonDetailHasDataState(tSeasonDetail));

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Page should display season detail content with has episodes',
        (WidgetTester tester) async {
      tvShowRecommendationsEmptyState();

      whenListen(
        mockGetSeasonDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          SeasonDetailHasDataState(testSeasonDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetSeasonDetailBloc.state, EmptyState());

      await expectLater(
        mockGetSeasonDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          SeasonDetailHasDataState(testSeasonDetail),
        ]),
      );

      expect(mockGetSeasonDetailBloc.state,
          SeasonDetailHasDataState(testSeasonDetail));

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Page should can be tapped icon back',
        (WidgetTester tester) async {
      tvShowRecommendationsEmptyState();

      whenListen(
        mockGetSeasonDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          SeasonDetailHasDataState(testSeasonDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetSeasonDetailBloc.state, EmptyState());

      await expectLater(
        mockGetSeasonDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          SeasonDetailHasDataState(testSeasonDetail),
        ]),
      );

      expect(mockGetSeasonDetailBloc.state,
          SeasonDetailHasDataState(testSeasonDetail));

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      await tester.tap(find.byType(IconButton));
    });
  });

  group('Show All States TV Show Recommendations', () {
    testWidgets('Page should display tv show recommendations empty state',
        (WidgetTester tester) async {
      initSeasonDetail();

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

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(
        find.byKey(Key('tv_show_recommendations_container_empty')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display tv show recommendations loading state',
        (WidgetTester tester) async {
      initSeasonDetail();

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

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(find.byKey(Key('tv_show_recommendations_center_loading')),
          findsOneWidget);
    });

    testWidgets('Page should display tv show recommendations is empty',
        (WidgetTester tester) async {
      initSeasonDetail();

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

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(
        find.byKey(Key('tv_show_recommendations_center_empty')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display tv show recommendations has data state',
        (WidgetTester tester) async {
      initSeasonDetail();

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

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(
        find.byKey(Key('tv_show_recommendations_container')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display tv show recommendations error state',
        (WidgetTester tester) async {
      initSeasonDetail();

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

      await tester.pumpWidget(
          _makeTestableWidget(SeasonDetailPage(tvShowDetail: tvShowDetail)));

      expect(
        find.byKey(Key('tv_show_recommendations_center_error')),
        findsOneWidget,
      );
    });
  });
}
