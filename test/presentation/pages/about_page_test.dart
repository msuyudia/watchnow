import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchnow/presentation/pages/about_page.dart';

void main() {
  Widget _makeTestableWidget() {
    return MaterialApp(
      home: AboutPage(),
    );
  }

  testWidgets('Page should display about page and can be tap icon back button',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget());
    expect(find.byType(Scaffold), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(IconButton));
  });
}
