import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import '../../items/domain/entities/product_entity.dart';
import '../../items/domain/usecases/create_product_usecase.dart';
import '../../items/domain/usecases/delete_product_usecase.dart';
import '../../items/domain/usecases/get_products_usecase.dart';
import '../../items/domain/usecases/update_product_usecase.dart';
import '../../items/domain/usecases/upload_image_usecase.dart';

class ItemsViewModel extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;
  final CreateProductUseCase createProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final UploadImageUseCase uploadImageUseCase;

  ItemsViewModel({
    required this.getProductsUseCase,
    required this.createProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
    required this.uploadImageUseCase,
  });

  bool loading = false;
  String? error;
  List<ProductEntity> items = [];

  Future<void> fetchProducts() async {
    try {
      loading = true; error = null; notifyListeners();
      items = await getProductsUseCase(const NoParams());
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<bool> createItem({
    required String name,
    required String description,
    required double price,
    File? imageFile,
  }) async {
    try {
      loading = true; error = null; notifyListeners();
      String url = '';
      if (imageFile != null) {
        final uploaded = await uploadImageUseCase(UploadImageParams(imageFile));
        if (uploaded == null) throw Exception('Image upload failed');
        url = uploaded;
      }
      final ok = await createProductUseCase(
        CreateProductParams(
          ProductEntity(name: name, description: description, price: price, url: url),
        ),
      );
      if (ok) await fetchProducts();
      return ok;
    } catch (e) {
      error = e.toString(); return false;
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<bool> updateItem({
    required String oldName,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
  }) async {
    try {
      loading = true; error = null; notifyListeners();
      final ok = await updateProductUseCase(
        UpdateProductParams(
          oldName: oldName,
          newValue: ProductEntity(name: name, description: description, price: price, url: imageUrl),
        ),
      );
      if (ok) await fetchProducts();
      return ok;
    } catch (e) {
      error = e.toString(); return false;
    } finally {
      loading = false; notifyListeners();
    }
  }

  Future<void> deleteByName(String name) async {
    try {
      await deleteProductUseCase(DeleteProductParams(name));
      await fetchProducts();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
