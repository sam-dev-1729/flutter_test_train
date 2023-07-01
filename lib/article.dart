class Article {
  String? title;
  String? content;

  Article({this.title, this.content});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Article && other.title == title && other.content == content;
  }

  @override
  int get hashCode => title.hashCode ^ content.hashCode;
}
