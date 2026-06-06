import 'package:flutter/material.dart';
import '../models/models.dart';
import '../widgets/cart_item_card.dart';
import '../database/database_helper6.dart';
import '../main.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadOrders() async {
    final data = await DatabaseHelper.getOrders();
    if (mounted) setState(() => orders = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Cart & Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF4F7F4),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: 'Cart'), Tab(text: 'My Orders')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildCartTab(), _buildOrdersTab()],
      ),
    );
  }

  Widget _buildCartTab() => Column(
        children: [
          Expanded(
            child: Cart.items.isEmpty
                ? const Center(child: Text("Your cart is empty", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: Cart.items.length,
                    itemBuilder: (context, i) => CartItemCard(
                      item: Cart.items[i],
                      onAdd: () => setState(() => Cart.items[i].quantity++),
                      onRemove: () => setState(() => Cart.items[i].quantity > 1 ? Cart.items[i].quantity-- : Cart.removeItem(i)),
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E7D5A),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                if (Cart.items.isEmpty) return;
                final user = await DatabaseHelper.getUser();
                await DatabaseHelper.insertOrder({
                  'customer': MyApp.userEmail ?? 'Guest',
                  'phone': user?['phone'] ?? '',
                  'address': user?['address'] ?? '',
                  'items': Cart.items.map((e) => e.name).join(", "),
                  'total': Cart.getTotal(),
                  'time': DateTime.now().toString(),
                  'status': 'Pending'
                });

                if (mounted) {
                  setState(() {
                    Cart.clear();
                    _loadOrders();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order placed successfully!')),
                  );
                }
              },
              child: const Text('Checkout Now', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      );

  Widget _buildOrdersTab() {
    final userOrders = orders.where((o) => o['customer'] == MyApp.userEmail).toList();

    return userOrders.isEmpty
        ? const Center(child: Text("No orders found for your account."))
        : ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: userOrders.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                title: Text("Order #${userOrders[i]['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Total: ${userOrders[i]['total']} LYD"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.receipt_long, color: Color(0xFF4E7D5A)),
                      onPressed: () => _showDetails(userOrders[i]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () async {
                        await DatabaseHelper.deleteOrder(userOrders[i]['id']);
                        _loadOrders();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  void _showDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("Invoice Details"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(order['items'].toString().replaceAll(', ', '\n')),
              const Divider(height: 20),
              Text("Total: ${order['total']} LYD", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text("Date: ${order['time']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("Close"))
        ],
      ),
    );
  }
}