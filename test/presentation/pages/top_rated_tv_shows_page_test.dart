import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/get_top_rated_tv_shows_bloc.dart';
import 'package:watchnow/presentation/pages/top_rated_tv_shows_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetTopRatedTVShowsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetTopRatedTVShowsBloc {}

void main() {
  late MockGetTopRatedTVShowsBloc mockGetTopRatedTVShowsBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetTopRatedTVShowsBloc = MockGetTopRatedTVShowsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetTopRatedTVShowsBloc>.value(
      value: mockGetTopRatedTVShowsBloc,
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
      mockGetTopRatedTVShowsBloc,
      Stream.fromIterable([
        TVShowsHasDataState(testTVShowList),
      ]),
      initialState: TVShowsHasDataState(testTVShowList),
    );

    await tester.pumpWidget(_makeTestableWidget(TopRatedTVShowsPage()));
    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Top Rated TV Shows Page', () {
    testWidgets('Page should display loading', (WidgetTester tester) async {
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

      final center = find.byType(Center);
      final loading = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(TopRatedTVShowsPage()));

      expect(center, findsOneWidget);
      expect(loading, findsOneWidget);
    });

    testWidgets('Page should display popular tv shows empty',
        (WidgetTester tester) async {
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

      expect(mockGetTopRatedTVShowsBloc.state, TVShowsHasDataState(<TVShow>[]));

      final centerEmpty = find.byKey(Key('center_empty'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTVShowsPage()));

      expect(centerEmpty, findsOneWidget);
    });

    testWidgets('Page should display popular tv shows',
        (WidgetTester tester) async {
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

      expect(mockGetTopRatedTVShowsBloc.state,
          TVShowsHasDataState(testTVShowList));

      final listView = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(TopRatedTVShowsPage()));

      expect(listView, findsOneWidget);
    });

    testWidgets('Page should display error', (WidgetTester tester) async {
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

      final centerError = find.byKey(Key('center_error'));

      await tester.pumpWidget(_makeTestableWidget(TopRatedTVShowsPage()));

      expect(centerError, findsOneWidget);
    });

    testWidgets('Page should display empty', (WidgetTester tester) async {
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

      final container = find.byType(Container);

      await tester.pumpWidget(_makeTestableWidget(TopRatedTVShowsPage()));

      expect(container, findsOneWidget);
    });
  });
}
