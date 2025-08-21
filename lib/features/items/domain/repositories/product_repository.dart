import 'dart:io';
import '../entities/product_entity.dart';

abstract class ProductRepository {
	Future<List<ProductEntity>> getProducts();
	Future<bool> deleteByName(String name);
	Future<bool> createItem(ProductEntity product);
	Future<bool> updateItem({
		required String oldName,
		required ProductEntity newValue,
	});
	Future<String?> uploadImage(File file);
}


