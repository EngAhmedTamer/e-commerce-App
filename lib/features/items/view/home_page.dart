import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_page.dart';
import 'edit_item_page.dart';
import '../../auth/view/login.dart';

import '../view_model/items_view_model.dart';
import '../repository/items_repository.dart';
import '../model/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];
  bool isLoading = true;

  late final ItemsViewModel _itemsVM = ItemsViewModel(ItemsRepository());

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    await _itemsVM.fetchProducts();
    if (!mounted) return;
    setState(() {
      products = _itemsVM.items;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purpleAccent, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    'Welcome 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  await Supabase.instance.client.auth.signOut();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                          (route) => false,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemPage()),
          );
          if (result == true) {
            await fetchProducts();
          }
        },
        child: const Icon(Icons.add),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child:
              isLoading
                  ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                  : Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Ahmed Store',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GridView.builder(
                            itemCount: products.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                ),
                                            child:
                                                product.url.isNotEmpty
                                                    ? AspectRatio(
                                                      aspectRatio: 1,
                                                      child: Image.network(
                                                        product.url,
                                                        fit: BoxFit.fill,
                                                        errorBuilder:
                                                            (
                                                              context,
                                                              error,
                                                              stackTrace,
                                                            ) => const Center(
                                                              child: Icon(
                                                                Icons
                                                                    .broken_image,
                                                                color:
                                                                    Colors
                                                                        .white,
                                                              ),
                                                            ),
                                                      ),
                                                    )
                                                    : const Center(
                                                      child: Icon(
                                                        Icons
                                                            .image_not_supported,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                product.description,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 12,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                '\$${product.price}',
                                                style: const TextStyle(
                                                  color: Colors.amberAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ),
                                      onSelected: (value) async {
                                        if (value == 'edit') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (_) => EditItemPage(
                                                    oldName: product.name,
                                                    oldDescription:
                                                        product.description,
                                                    oldPrice: product.price.toInt(),
                                                    oldImageUrl: product.url,
                                                  ),
                                            ),
                                          ).then((value) async {
                                            if (value == true) {
                                              await fetchProducts();
                                            }
                                          });
                                        } else if (value == 'delete') {
                                          await _itemsVM.deleteByName(product.name);
                                          await fetchProducts();
                                        }
                                      },
                                      itemBuilder:
                                          (BuildContext context) => const [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Text('edit ✏️'),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text(' delete 🗑️ '),
                                            ),
                                          ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
