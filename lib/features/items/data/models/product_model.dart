import '../../domain/entities/product_entity.dart';

class ProductModel {
	final String name;
	final String description;
	final double price;
	final String url;

	const ProductModel({
		required this.name,
		required this.description,
		required this.price,
		required this.url,
	});

	factory ProductModel.fromMap(Map<String, dynamic> m) => ProductModel(
		name: m['name'] ?? '',
		description: m['description'] ?? '',
		price: (m['price'] is num)
			? (m['price'] as num).toDouble()
			: double.tryParse('${m['price']}') ?? 0.0,
		url: m['url'] ?? '',
	);

	Map<String, dynamic> toMap() => {
		'name': name,
		'description': description,
		'price': price,
		'url': url,
	};

	ProductEntity toEntity() => ProductEntity(
		name: name,
		description: description,
		price: price,
		url: url,
	);

	static ProductModel fromEntity(ProductEntity e) => ProductModel(
		name: e.name,
		description: e.description,
		price: e.price,
		url: e.url,
	);
}


