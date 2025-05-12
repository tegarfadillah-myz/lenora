class Article {
  final int id;
  final String name;
  final String thumbnail;
  final String content;
  final int categoryId;
  final String isFeatured;
  final String categoryName;

  Article({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.content,
    required this.categoryId,
    required this.isFeatured,
    required this.categoryName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      content: json['content'],
      categoryId: json['category_id'],
      isFeatured: json['is_featured'],
      categoryName: json['category']['name'],
    );
  }
}
