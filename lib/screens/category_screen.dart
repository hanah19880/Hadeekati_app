import 'package:flutter/material.dart';
import '../database/database_helper6.dart';
import '../widgets/product_card.dart';
import '../models/models.dart';
import '../main.dart';

class CategoryScreen extends StatefulWidget {
  final String? selectedCategory;
  const CategoryScreen({this.selectedCategory, super.key});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<ProductModel> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);

    List<Map<String, dynamic>> data;

    if (widget.selectedCategory != null) {
      data = await DatabaseHelper.getProductsByCategory(widget.selectedCategory!);
    } else {
      data = await DatabaseHelper.getProducts();
    }

    if (!mounted) return;

    setState(() {
      products = data.map((e) => ProductModel.fromMap(e)).toList();
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadData();
  }

  @override
  void didUpdateWidget(covariant CategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
        title: Text(
          widget.selectedCategory ?? "All Plants",
          style: const TextStyle(
            color: Color(0xFF1E3525),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF4E7D5A)),
            )
          : products.isEmpty
              ? Center(
                  child: Text(
                    "No products found here 🌿",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.78,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return ProductCard(
                      product: product,
                      isAdmin: MyApp.isAdmin,
                      onAddToCart: () {
                        if (MyApp.isGuest) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Guests cannot add items to cart'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        Cart.addItem(product.name, product.price, 1);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Added ${product.name}"),
                            backgroundColor: const Color(0xFF4E7D5A),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}