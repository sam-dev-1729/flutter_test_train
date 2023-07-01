import 'package:flutter/material.dart';
import 'package:flutter_my/article.dart';
import 'package:flutter_my/news_provider.dart';
import 'package:flutter_my/news_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: ChangeNotifierProvider(
        create: (context) => NewsChangeNotifier(NewsService()),
        child: const NewsPage(),
      ),
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<NewsChangeNotifier>().getArticle(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('News'),
        ),
        body: Consumer<NewsChangeNotifier>(
          builder: (context, ctl, child) {
            if (ctl.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.separated(
              itemCount: ctl.articles.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                var article = ctl.articles[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ArticlePage(article: article)));
                    },
                    child: ListTile(
                      title: Text(article.title ?? ''),
                      subtitle: Text(
                        article.content ?? '',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}

class ArticlePage extends StatefulWidget {
  const ArticlePage({super.key, required this.article});
  final Article article;

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          Text(widget.article.title ?? ' '),
          const SizedBox(
            height: 20,
          ),
          Text(widget.article.title ?? ' '),
        ]),
      )),
    );
  }
}
