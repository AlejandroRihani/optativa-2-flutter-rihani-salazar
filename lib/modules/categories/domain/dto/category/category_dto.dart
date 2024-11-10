class Category {
  final String slug;
  final String name;
  final String url;
  String? firstProductImage; // Imagen del primer producto

  Category({
    required this.slug,
    required this.name,
    required this.url,
    this.firstProductImage,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      slug: json['slug'],
      name: json['name'],
      url: json['url'],
    );
  }
}
