import 'package:flutter_my/article.dart';
import 'package:flutter_my/news_provider.dart';
import 'package:flutter_my/news_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    'articles',
    () {
      expect(sut.articles, []);
    },
  );

  group('get article', () {
    final articleFromService = [
      Article(title: 'Test 1', content: 'Test 1 content'),
      Article(title: 'Test 2', content: 'Test 2 content'),
      Article(title: 'Test 3', content: 'Test 3 content'),
    ];
    void arrageNewsServiceReturns3Articales() {
      when(() => mockNewsService.getArticles())
          .thenAnswer((_) async => articleFromService);
    }

    test(
      'gets articles using newsService',
      () async {
        // aranage
        arrageNewsServiceReturns3Articales();
        // act
        await sut.getArticle();
        // assert
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );

    test(
      """indecates loading of data""",
      () async {
        arrageNewsServiceReturns3Articales();
        final future = sut.getArticle();
        expect(sut.isLoading, true);
        await future;
        expect(sut.isLoading, false);
        expect(sut.articles, articleFromService);
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );
  });
}
