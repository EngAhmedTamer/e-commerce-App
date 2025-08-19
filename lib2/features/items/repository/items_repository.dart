import 'dart:io';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/product.dart';

class ItemsRepository {
  final SupabaseClient _client = Supabase.instance.client;
  static const _table = 'items';

  Future<List<Product>> fetchProducts() async {
    final res = await _client.from(_table).select();
    return List<Map<String, dynamic>>.from(res).map(Product.fromMap).toList();
  }

  Future<bool> deleteByName(String name) async {
    await _client.from(_table).delete().eq('name', name);
    return true;
  }

  Future<String?> uploadImage(File file) async {
    final storage = _client.storage.from('images');
    final fileName = 'item_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final mimeType = lookupMimeType(file.path);
    final fileBytes = await file.readAsBytes();
    await storage.uploadBinary(fileName, fileBytes, fileOptions: FileOptions(contentType: mimeType));
    return storage.getPublicUrl(fileName);
  }

  Future<bool> createItem(Product p) async {
    await _client.from(_table).insert(p.toMap());
    return true;
  }

  Future<bool> updateItem({
    required String oldName,
    required Product newValue,
  }) async {
    await _client.from(_table).update(newValue.toMap()).eq('name', oldName);
    return true;
  }
}
