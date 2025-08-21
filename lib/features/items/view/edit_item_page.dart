import 'package:flutter/material.dart';

import '../view_model/items_view_model.dart';
import 'package:ecommerce/di.dart';

class EditItemPage extends StatefulWidget {
  final String oldName;
  final String oldDescription;
  final int oldPrice;
  final String oldImageUrl;

  const EditItemPage({
    super.key,
    required this.oldName,
    required this.oldDescription,
    required this.oldPrice,
    required this.oldImageUrl,
  });

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController imageUrlController;

  late final ItemsViewModel _itemsVM = sl.get<ItemsViewModel>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.oldName);
    descriptionController = TextEditingController(text: widget.oldDescription);
    priceController = TextEditingController(text: widget.oldPrice.toString());
    imageUrlController = TextEditingController(text: widget.oldImageUrl);
  }

  Future<void> updateItem() async {
    try {
      final ok = await _itemsVM.updateItem(
        oldName: widget.oldName,
        name: nameController.text,
        description: descriptionController.text,
        price: double.tryParse(priceController.text) ?? 0,
        imageUrl: imageUrlController.text,
      );
      if (!mounted) return;
      if (ok) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_itemsVM.error ?? 'فشل التحديث')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل التحديث: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit"),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE1BEE7),Color(0xFF9C27B0)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTextField(nameController, "Name", Icons.edit),
                const SizedBox(height: 12),
                _buildTextField(descriptionController, "Description", Icons.description),
                const SizedBox(height: 12),
                _buildTextField(priceController, "price", Icons.price_change, isNumber: true),
                const SizedBox(height: 12),
                _buildTextField(imageUrlController, "image url ", Icons.image),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1B9A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Update it",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}
