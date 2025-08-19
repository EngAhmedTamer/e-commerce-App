class Product {
  final String name;
  final String description;
  final double price;
  final String url;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.url,
  });

  factory Product.fromMap(Map<String, dynamic> m) => Product(
    name: m['name'] ?? '',
    description: m['description'] ?? '',
    price: (m['price'] is num) ? (m['price'] as num).toDouble() : double.tryParse('${m['price']}') ?? 0.0,
    url: m['url'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'name': name,
    'description': description,
    'price': price,
    'url': url,
  };
}
