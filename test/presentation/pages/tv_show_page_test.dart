import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/get_on_the_air_tv_shows_bloc.dart';
import 'package:watchnow/presentation/bloc/get_popular_tv_shows_bloc.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_tv_shows_bloc.dart';
import 'package:watchnow/presentation/pages/popular_tv_shows_page.dart';
import 'package:watchnow/presentation/pages/search_tv_show_page.dart';
import 'package:watchnow/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';
import 'package:watchnow/presentation/pages/tv_show_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetOnTheAirTVShowsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetOnTheAirTVShowsBloc {}

class MockGetPopularTVShowsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetPopularTVShowsBloc {}

class MockGetTopRatedTVShowsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetTopRatedTVShowsBloc {}

void main() {
  late MockGetOnTheAirTVShowsBloc mockGetOnTheAirTVShowsBloc;
  late MockGetPopularTVShowsBloc mockGetPopularTVShowsBloc;
  late MockGetTopRatedTVShowsBloc mockGetTopRatedTVShowsBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetOnTheAirTVShowsBloc = MockGetOnTheAirTVShowsBloc();
    mockGetPopularTVShowsBloc = MockGetPopularTVShowsBloc();
    mockGetTopRatedTVShowsBloc = MockGetTopRatedTVShowsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetOnTheAirTVShowsBloc>.value(
          value: mockGetOnTheAirTVShowsBloc,
        ),
        BlocProvider<GetPopularTVShowsBloc>.value(
          value: mockGetPopularTVShowsBloc,
        ),
        BlocProvider<GetTopRatedTVShowsBloc>.value(
          value: mockGetTopRatedTVShowsBloc,
        ),
      ],
      child: MaterialApp(
        home: TVShowPage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case PopularTVShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTVShowsPage());
            case TopRatedTVShowsPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTVShowsPage());
            case TVShowDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TVShowDetailPage(id: id),
                settings: settings,
              );
            case SearchTVShowPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTVShowPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }

  void onTheAirTVShowsEmptyState() async {
    whenListen(
      mockGetOnTheAirTVShowsBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  void popularTVShowsEmptyState() async {
    whenListen(
      mockGetPopularTVShowsBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  void topRatedTVShowsEmptyState() async {
    whenListen(
      mockGetTopRatedTVShowsBloc,
      Stream.fromIterable([
        EmptyState(),
      ]),
      initialState: EmptyState(),
    );
  }

  group('Verify All Tap Action For All Tappable Widgets In TV Show Page', () {
    testWidgets('Page should can be tap search icon button',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('search_icon_button')));
    });

    testWidgets('Page should can be tap see more in above popular list',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));
      await tester.tap(find.byKey(Key('popular_sub_heading')));
    });

    testWidgets('Page should can be tap see more in above top rated list',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));
      await tester.tap(find.byKey(Key('top_rated_sub_heading')));
    });

    testWidgets('Page should can be tap item tv show in on the air list',
        (WidgetTester tester) async {
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      whenListen(
        mockGetOnTheAirTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetOnTheAirTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(
        mockGetOnTheAirTVShowsBloc.state,
        TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));
      await tester.tap(find.byKey(Key('on_the_air_inkwell')));
    });

    testWidgets('Page should can be tap item tv show in popular list',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      whenListen(
        mockGetPopularTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetPopularTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(
        mockGetPopularTVShowsBloc.state,
        TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));
      await tester.tap(find.byKey(Key('popular_inkwell')));
    });

    testWidgets('Page should can be tap item tv show in top rated list',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();

      whenListen(
        mockGetTopRatedTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      await expectLater(
        mockGetTopRatedTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(
        mockGetTopRatedTVShowsBloc.state,
        TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));
      await tester.tap(find.byKey(Key('top_rated_inkwell')));
    });
  });

  group('Show All States On The Air Playing TV Shows', () {
    testWidgets('Page should display on the air tv shows empty state',
        (WidgetTester tester) async {
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();
      whenListen(
        mockGetOnTheAirTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetOnTheAirTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetOnTheAirTVShowsBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(
          find.byKey(Key('on_the_air_empty_state_container')), findsOneWidget);
    });

    testWidgets('Page should display on the air tv shows loading state',
        (WidgetTester tester) async {
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();
      whenListen(
        mockGetOnTheAirTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetOnTheAirTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetOnTheAirTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetOnTheAirTVShowsBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('on_the_air_loading')), findsOneWidget);
    });

    testWidgets('Page should display on the air tv shows error state',
        (WidgetTester tester) async {
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      whenListen(
        mockGetOnTheAirTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetOnTheAirTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetOnTheAirTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetOnTheAirTVShowsBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('on_the_air_error_container')), findsOneWidget);
    });

    testWidgets('Page should display on the air tv shows is empty',
        (WidgetTester tester) async {
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      whenListen(
        mockGetOnTheAirTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetOnTheAirTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetOnTheAirTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
      );

      expect(
        mockGetOnTheAirTVShowsBloc.state,
        TVShowsHasDataState(<TVShow>[]),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('on_the_air_empty_container')), findsOneWidget);
    });

    testWidgets('Page should display on the air tv shows',
        (WidgetTester tester) async {
      popularTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      whenListen(
        mockGetOnTheAirTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetOnTheAirTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetOnTheAirTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(
        mockGetOnTheAirTVShowsBloc.state,
        TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('on_the_air_tv_shows_container')), findsOneWidget);
    });
  });

  group('Show All States Popular TV Shows', () {
    testWidgets('Page should display popular tv shows empty state',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      topRatedTVShowsEmptyState();
      whenListen(
        mockGetPopularTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetPopularTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetPopularTVShowsBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('popular_empty_state_container')), findsOneWidget);
    });

    testWidgets('Page should display popular tv shows loading state',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      topRatedTVShowsEmptyState();
      whenListen(
        mockGetPopularTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetPopularTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetPopularTVShowsBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('popular_loading')), findsOneWidget);
    });

    testWidgets('Page should display popular tv shows error state',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      whenListen(
        mockGetPopularTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetPopularTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetPopularTVShowsBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('popular_error_container')), findsOneWidget);
    });

    testWidgets('Page should display popular tv shows is empty',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      whenListen(
        mockGetPopularTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetPopularTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
      );

      expect(
        mockGetPopularTVShowsBloc.state,
        TVShowsHasDataState(<TVShow>[]),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('popular_empty_container')), findsOneWidget);
    });

    testWidgets('Page should display popular tv shows',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      topRatedTVShowsEmptyState();

      whenListen(
        mockGetPopularTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetPopularTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetPopularTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(
        mockGetPopularTVShowsBloc.state,
        TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('popular_tv_shows_container')), findsOneWidget);
    });
  });

  group('Show All States Top Rated TV Shows', () {
    testWidgets('Page should display top rated tv shows empty state',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();
      whenListen(
        mockGetTopRatedTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
        ]),
      );

      await expectLater(
        mockGetTopRatedTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
        ]),
      );

      expect(mockGetTopRatedTVShowsBloc.state, EmptyState());

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(
          find.byKey(Key('top_rated_empty_state_container')), findsOneWidget);
    });

    testWidgets('Page should display top rated tv shows loading state',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();
      whenListen(
        mockGetTopRatedTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTopRatedTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetTopRatedTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
        ]),
      );

      expect(mockGetTopRatedTVShowsBloc.state, LoadingState());

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('top_rated_loading')), findsOneWidget);
    });

    testWidgets('Page should display top rated tv shows error state',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();

      whenListen(
        mockGetTopRatedTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTopRatedTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetTopRatedTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          ErrorState('Error message'),
        ]),
      );

      expect(mockGetTopRatedTVShowsBloc.state, ErrorState('Error message'));

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('top_rated_error_container')), findsOneWidget);
    });

    testWidgets('Page should display top rated tv shows is empty',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();

      whenListen(
        mockGetTopRatedTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTopRatedTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetTopRatedTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(<TVShow>[]),
        ]),
      );

      expect(
        mockGetTopRatedTVShowsBloc.state,
        TVShowsHasDataState(<TVShow>[]),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('top_rated_empty_container')), findsOneWidget);
    });

    testWidgets('Page should display top rated tv shows',
        (WidgetTester tester) async {
      onTheAirTVShowsEmptyState();
      popularTVShowsEmptyState();

      whenListen(
        mockGetTopRatedTVShowsBloc,
        Stream.fromIterable([
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
        initialState: EmptyState(),
      );

      expect(mockGetTopRatedTVShowsBloc.state, EmptyState());

      await expectLater(
        mockGetTopRatedTVShowsBloc.stream,
        emitsInOrder(<BlocState>[
          EmptyState(),
          LoadingState(),
          TVShowsHasDataState(testTVShowList),
        ]),
      );

      expect(
        mockGetTopRatedTVShowsBloc.state,
        TVShowsHasDataState(testTVShowList),
      );

      await tester.pumpWidget(_makeTestableWidget(TVShowPage()));

      expect(find.byKey(Key('top_rated_tv_shows_container')), findsOneWidget);
    });
  });
}
