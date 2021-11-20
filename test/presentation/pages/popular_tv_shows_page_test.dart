import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchnow/common/bloc_event.dart';
import 'package:watchnow/common/bloc_state.dart';
import 'package:watchnow/domain/entities/tv_show.dart';
import 'package:watchnow/presentation/bloc/get_popular_tv_shows_bloc.dart';
import 'package:watchnow/presentation/pages/popular_tv_shows_page.dart';
import 'package:watchnow/presentation/pages/tv_show_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.dart';

class MockGetPopularTVShowsBloc extends MockBloc<BlocEvent, BlocState>
    implements GetPopularTVShowsBloc {}

void main() {
  late MockGetPopularTVShowsBloc mockGetPopularTVShowsBloc;

  setUp(() {
    registerFallbackValue(FakeBlocEvent());
    registerFallbackValue(FakeBlocState());
    mockGetPopularTVShowsBloc = MockGetPopularTVShowsBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetPopularTVShowsBloc>.value(
      value: mockGetPopularTVShowsBloc,
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
      mockGetPopularTVShowsBloc,
      Stream.fromIterable([
        TVShowsHasDataState(testTVShowList),
      ]),
      initialState: TVShowsHasDataState(testTVShowList),
    );

    await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));
    await tester.tap(find.byType(InkWell));
  });

  group('Show All States Popular TV Shows Page', () {
    testWidgets('Page should display loading', (WidgetTester tester) async {
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

      final center = find.byType(Center);
      final loading = find.byType(CircularProgressIndicator);

      await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

      expect(center, findsOneWidget);
      expect(loading, findsOneWidget);
    });

    testWidgets('Page should display popular tv shows empty',
        (WidgetTester tester) async {
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

      expect(mockGetPopularTVShowsBloc.state, TVShowsHasDataState(<TVShow>[]));

      final centerEmpty = find.byKey(Key('center_empty'));

      await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

      expect(centerEmpty, findsOneWidget);
    });

    testWidgets('Page should display popular tv shows',
        (WidgetTester tester) async {
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
          mockGetPopularTVShowsBloc.state, TVShowsHasDataState(testTVShowList));

      final listView = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

      expect(listView, findsOneWidget);
    });

    testWidgets('Page should display error', (WidgetTester tester) async {
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

      final centerError = find.byKey(Key('center_error'));

      await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

      expect(centerError, findsOneWidget);
    });

    testWidgets('Page should display empty', (WidgetTester tester) async {
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

      final container = find.byType(Container);

      await tester.pumpWidget(_makeTestableWidget(PopularTVShowsPage()));

      expect(container, findsOneWidget);
    });
  });
}
