import 'package:flutter/foundation.dart';
import 'package:flutter_my/news_service.dart';

import 'article.dart';

class NewsChangeNotifier extends ChangeNotifier {
  final NewsService _newsService;
  NewsChangeNotifier(this._newsService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  Future<void> getArticle() async {
    _isLoading = true;
    notifyListeners();
    _articles = await _newsService.getArticles();
    _isLoading = false;
    notifyListeners();
  }
}
