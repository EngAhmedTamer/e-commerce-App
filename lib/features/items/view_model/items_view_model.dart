import 'dart:io';
import 'package:flutter/foundation.dart';
import '../model/product.dart';
import '../repository/items_repository.dart';

class ItemsViewModel extends ChangeNotifier {
  final ItemsRepository _repo;
  ItemsViewModel(this._repo);

  bool loading = false;
  String? error;
  List<Product> items = [];

  Future<void> fetchProducts() async {
    try {
      loading = true; error = null; notifyListeners();
      items = await _repo.fetchProducts();
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
        final uploaded = await _repo.uploadImage(imageFile);
        if (uploaded == null) throw Exception('Image upload failed');
        url = uploaded;
      }
      final ok = await _repo.createItem(Product(name: name, description: description, price: price, url: url));
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
      final ok = await _repo.updateItem(
        oldName: oldName,
        newValue: Product(name: name, description: description, price: price, url: imageUrl),
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
      await _repo.deleteByName(name);
      await fetchProducts();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }
}
