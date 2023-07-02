import 'package:flutter/material.dart';
import 'package:flutter_my/article.dart';
import 'package:flutter_my/main.dart';
import 'package:flutter_my/news_provider.dart';
import 'package:flutter_my/news_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articleFromService = [
    Article(title: 'Test 1', content: 'Test 1 content'),
    Article(title: 'Test 2', content: 'Test 2 content'),
    Article(title: 'Test 3', content: 'Test 3 content'),
  ];
  void arrageNewsServiceReturns3Articales() {
    when(() => mockNewsService.getArticles())
        .thenAnswer((_) async => articleFromService);
  }

  createWidgetUnderTest() {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: ChangeNotifierProvider(
        create: (context) => NewsChangeNotifier(mockNewsService),
        child: const NewsPage(),
      ),
    );
  }

  testWidgets('integration test for app', (widgetTester) async {
    arrageNewsServiceReturns3Articales();

    await widgetTester.pumpWidget(createWidgetUnderTest());

    await widgetTester.pump();
    await widgetTester.tap(find.text('Test 1 content'));
    await widgetTester.pumpAndSettle();

    expect(find.byType(NewsPage), findsNothing);
    expect(find.byType(ArticlePage), findsOneWidget);
  });
}
