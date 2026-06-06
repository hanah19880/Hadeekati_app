import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import '../main.dart';
import '../models/models.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';
import 'category_screen.dart';
import 'profile_screen.dart';
import 'cart_screen.dart';
import 'admin_panel_screen.dart';
import '../database/database_helper6.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late CircularBottomNavigationController _navigationController;
  List<ProductModel> productsList = [];
  bool isProductsLoading = true;

  final List<CategoryModel> categories = [
    CategoryModel(title: "Indoor Plants", image: "images/a.jpg"),
    CategoryModel(title: "Climbing Plants", image: "images/d.jpg"),
    CategoryModel(title: "Succulents", image: "images/h.jpg"),
    CategoryModel(title: "Flowers", image: "images/j.jpg"),
  ];

  @override
  void initState() {
    super.initState();
    _navigationController = CircularBottomNavigationController(_selectedIndex);
    loadAllProducts();
  }

  void loadAllProducts() async {
    final data = await DatabaseHelper.getBestSellerProducts();
    setState(() {
      productsList = data.map((e) => ProductModel.fromMap(e)).toList();
      isProductsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          const CategoryScreen(),
          MyApp.isAdmin
              ? AdminPanelScreen(
                  navController: _navigationController,
                  onNavigate: (i) => setState(() => _selectedIndex = i),
                )
              : CartScreen(key: UniqueKey()),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: CircularBottomNavigation(
        [
          TabItem(Icons.home_outlined, "Home", const Color(0xFF4E7D5A)),
          TabItem(Icons.grid_view_rounded, "Products", const Color(0xFF4E7D5A)),
          MyApp.isAdmin
              ? TabItem(Icons.admin_panel_settings_outlined, "Dashboard", const Color(0xFF4E7D5A))
              : TabItem(Icons.shopping_cart_outlined, "Cart", const Color(0xFF4E7D5A)),
          TabItem(Icons.person_outline, "Profile", const Color(0xFF4E7D5A)),
        ],
        controller: _navigationController,
        selectedPos: _selectedIndex,
        barHeight: 60,
        circleSize: 50,
        selectedCallback: (pos) {
          setState(() {
            _selectedIndex = pos ?? 0;
          });
          if ((pos ?? 0) == 0) {
            loadAllProducts();
          }
        },
      ),
    );
  }

  Widget _buildHomeTab() => Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 80,
          title: const _HomeHeader(),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const _PromoCard(),
            const SizedBox(height: 20),
            const Text("Plant Categories", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E3525))),
            const SizedBox(height: 15),
            _buildCategoryList(),
            const SizedBox(height: 20),
            const Text("Best Sellers", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E3525))),
            const SizedBox(height: 10),
            isProductsLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF4E7D5A)))
                : _buildProductGrid(),
          ],
        ),
      );

  Widget _buildCategoryList() => SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, i) => CategoryCard(
            category: categories[i],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CategoryScreen(selectedCategory: categories[i].title),
              ),
            ),
          ),
        ),
      );

  Widget _buildProductGrid() => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: productsList.length,
        itemBuilder: (context, i) => ProductCard(
          product: productsList[i],
          isAdmin: MyApp.isAdmin,
          onAddToCart: () {
            if (MyApp.isGuest) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Please login to add to cart!")),
              );
              return;
            }

            Cart.addItem(productsList[i].name, productsList[i].price, 1);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Added ${productsList[i].name}"),
                backgroundColor: const Color(0xFF4E7D5A),
              ),
            );
          },
        ),
      );
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();
  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello, Green Lover!", style: TextStyle(fontSize: 14, color: Color(0xFF8A9A8A))),
                Text("Find Your Perfect Plant", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          ),
          Image.asset('images/logo.png', width: 120, height: 120),
        ],
      );
}

class _PromoCard extends StatelessWidget {
  const _PromoCard();
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 81, 112, 79),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Get 20% Off", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text("Today's special offer on all indoor\nclimbing plants.", style: TextStyle(color: Color(0xFFE0EAE0), fontSize: 13)),
          ],
        ),
      );
}