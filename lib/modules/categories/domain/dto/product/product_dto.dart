class Product {
  final int id;
  final String name;
  final String image;
  final String description;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['title'],
      image: json['thumbnail'],
      description: json['description'],
      price: json['price'].toDouble(),
      stock: json['stock'],
    );
  }
}
