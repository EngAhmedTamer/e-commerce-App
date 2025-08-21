import 'dart:io';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
	Future<List<ProductModel>> getProducts();
	Future<bool> deleteByName(String name);
	Future<String?> uploadImage(File file);
	Future<bool> createItem(ProductModel product);
	Future<bool> updateItem({required String oldName, required ProductModel newValue});
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
	final SupabaseClient client;
	static const _table = 'items';

	ProductRemoteDataSourceImpl({required this.client});

	@override
	Future<List<ProductModel>> getProducts() async {
		final res = await client.from(_table).select();
		return List<Map<String, dynamic>>.from(res).map(ProductModel.fromMap).toList();
	}

	@override
	Future<bool> deleteByName(String name) async {
		await client.from(_table).delete().eq('name', name);
		return true;
	}

	@override
	Future<String?> uploadImage(File file) async {
		final storage = client.storage.from('images');
		final fileName = 'item_${DateTime.now().millisecondsSinceEpoch}.jpg';
		final mimeType = lookupMimeType(file.path);
		final fileBytes = await file.readAsBytes();
		await storage.uploadBinary(fileName, fileBytes, fileOptions: FileOptions(contentType: mimeType));
		return storage.getPublicUrl(fileName);
	}

	@override
	Future<bool> createItem(ProductModel product) async {
		await client.from(_table).insert(product.toMap());
		return true;
	}

	@override
	Future<bool> updateItem({required String oldName, required ProductModel newValue}) async {
		await client.from(_table).update(newValue.toMap()).eq('name', oldName);
		return true;
	}
}


