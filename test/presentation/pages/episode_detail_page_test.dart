import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/common/constants.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/get_episode_detail_bloc.dart';
import 'package:watchnow/presentation/bloc/get_tv_show_recommendations_bloc.dart';
import 'package:watchnow/presentation/pages/episode_detail_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetEpisodeDetailBloc extends MockBloc<BlocEvent, BlocState>
    implements GetEpisodeDetailBloc {}

class MockGetTVShowRecommendationsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetTVShowRecommendationsBloc {}

void main() {
  late MockGetEpisodeDetailBloc mockGetEpisodeDetailBloc;
  late MockGetTVShowRecommendationsBloc mockGetTVShowRecommendationsBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetEpisodeDetailBloc = MockGetEpisodeDetailBloc();
    mockGetTVShowRecommendationsBloc = MockGetTVShowRecommendationsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetEpisodeDetailBloc>.value(
          value: mockGetEpisodeDetailBloc,
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
                    builder: (_) => TVShowDetailPage(id: 1));
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

  void initEpisodeDetail() async {
    whenListen(
      mockGetEpisodeDetailBloc,
      Stream.fromIterable([
        EpisodeDetailHasDataState(testEpisodeDetail),
      ]),
      initialState: EpisodeDetailHasDataState(testEpisodeDetail),
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

  final seasonDetailMap = {TV_SHOW_ID: 1, SEASON_NUMBER: 1, EPISODE_NUMBER: 1};

  testWidgets('Page should can be tap item tv show recommendations',
      (WidgetTester tester) async {
    initEpisodeDetail();
    whenListen(
      mockGetTVShowRecommendationsBloc,
      Stream.fromIterable([
        TVShowsHasDataState(testTVShowList),
      ]),
      initialState: TVShowsHasDataState(testTVShowList),
    );

    await tester.pumpWidget(_makeTestableWidget(
      EpisodeDetailPage(
        seasonDetail: seasonDetailMap,
      ),
    ));

    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Get Episode Detail', () {
    testWidgets('Page should display episode detail empty state',
        (WidgetTester tester) async {
      whenListen(
        mockGetEpisodeDetailBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetEpisodeDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetEpisodeDetailBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(find.byKey(Key('episode_detail_container_empty')), findsOneWidget);
    });

    testWidgets('Page should display episode detail loading',
        (WidgetTester tester) async {
      whenListen(
        mockGetEpisodeDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetEpisodeDetailBloc.state, EmptyState());

      await expectLater(
        mockGetEpisodeDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetEpisodeDetailBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(find.byKey(Key('episode_detail_center_loading')), findsOneWidget);
    });

    testWidgets('Page should display episode detail error',
        (WidgetTester tester) async {
      whenListen(
        mockGetEpisodeDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetEpisodeDetailBloc.state, EmptyState());

      await expectLater(
        mockGetEpisodeDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetEpisodeDetailBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(find.byKey(Key('episode_detail_center_error')), findsOneWidget);
    });

    testWidgets('Page should display episode detail content',
        (WidgetTester tester) async {
      tvShowRecommendationsEmptyState();

      whenListen(
        mockGetEpisodeDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          EpisodeDetailHasDataState(testEpisodeDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetEpisodeDetailBloc.state, EmptyState());

      await expectLater(
        mockGetEpisodeDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          EpisodeDetailHasDataState(testEpisodeDetail),
        ]),
      );

      expect(mockGetEpisodeDetailBloc.state,
          EpisodeDetailHasDataState(testEpisodeDetail));

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('Page should can be tapped icon back',
        (WidgetTester tester) async {
      tvShowRecommendationsEmptyState();

      whenListen(
        mockGetEpisodeDetailBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          EpisodeDetailHasDataState(testEpisodeDetail),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetEpisodeDetailBloc.state, EmptyState());

      await expectLater(
        mockGetEpisodeDetailBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          EpisodeDetailHasDataState(testEpisodeDetail),
        ]),
      );

      expect(mockGetEpisodeDetailBloc.state,
          EpisodeDetailHasDataState(testEpisodeDetail));

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      await tester.tap(find.byType(IconButton));
    });
  });

  group('Show All States TV Show Recommendations', () {
    testWidgets('Page should display tv show recommendations empty state',
        (WidgetTester tester) async {
      initEpisodeDetail();

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

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(
        find.byKey(Key('tv_show_recommendations_container_empty')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display tv show recommendations loading state',
        (WidgetTester tester) async {
      initEpisodeDetail();

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

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(find.byKey(Key('tv_show_recommendations_center_loading')),
          findsOneWidget);
    });

    testWidgets('Page should display tv show recommendations is empty',
        (WidgetTester tester) async {
      initEpisodeDetail();

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

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(
        find.byKey(Key('tv_show_recommendations_center_empty')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display tv show recommendations has data state',
        (WidgetTester tester) async {
      initEpisodeDetail();

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

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(
        find.byKey(Key('tv_show_recommendations_container')),
        findsOneWidget,
      );
    });

    testWidgets('Page should display tv show recommendations error state',
        (WidgetTester tester) async {
      initEpisodeDetail();

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

      await tester.pumpWidget(_makeTestableWidget(
          EpisodeDetailPage(seasonDetail: seasonDetailMap)));

      expect(
        find.byKey(Key('tv_show_recommendations_center_error')),
        findsOneWidget,
      );
    });
  });
}
