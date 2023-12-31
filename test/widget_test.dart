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

  void arrageNewsServiceReturns3ArticalesAfter2SecondsWait() {
    when(() => mockNewsService.getArticles()).thenAnswer((_) async {
      await Future.delayed(const Duration(seconds: 2));
      return articleFromService;
    });
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

  testWidgets('title is displayed', (widgetTester) async {
    arrageNewsServiceReturns3Articales();
    await widgetTester.pumpWidget(createWidgetUnderTest());
    expect(find.text('News'), findsOneWidget);
  });

  testWidgets('description', (widgetTester) async {
    arrageNewsServiceReturns3ArticalesAfter2SecondsWait();

    await widgetTester.pumpWidget(createWidgetUnderTest());

    await widgetTester.pump(const Duration(milliseconds: 500));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    widgetTester.pumpAndSettle();
  });
  testWidgets('get articles ', (widgetTester) async {
    arrageNewsServiceReturns3Articales();

    await widgetTester.pumpWidget(createWidgetUnderTest());

    await widgetTester.pump();

    for (final article in articleFromService) {
      expect(find.text(article.title!), findsOneWidget);
      expect(find.text(article.title!), findsOneWidget);
    }
  });
}
