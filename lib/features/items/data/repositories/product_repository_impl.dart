import 'dart:io';

import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
	final ProductRemoteDataSource remoteDataSource;

	ProductRepositoryImpl(this.remoteDataSource);

	@override
	Future<List<ProductEntity>> getProducts() async {
		final productModels = await remoteDataSource.getProducts();
		return productModels.map((m) => m.toEntity()).toList();
	}

	@override
	Future<bool> deleteByName(String name) async {
		return await remoteDataSource.deleteByName(name);
	}

	@override
	Future<bool> createItem(ProductEntity product) async {
		return await remoteDataSource.createItem(ProductModel.fromEntity(product));
	}

	@override
	Future<bool> updateItem({required String oldName, required ProductEntity newValue}) async {
		return await remoteDataSource.updateItem(oldName: oldName, newValue: ProductModel.fromEntity(newValue));
	}

	@override
	Future<String?> uploadImage(File file) async {
		return await remoteDataSource.uploadImage(file);
	}
}


