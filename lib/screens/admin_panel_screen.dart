import 'package:flutter/material.dart';
import '../database/database_helper6.dart';
import '../widgets/admin_list_item.dart';
import 'home_screen.dart';

// شاشة لوحة تحكم الأدمن 
class AdminPanelScreen extends StatefulWidget {
  final dynamic navController;
  final dynamic onNavigate;

  const AdminPanelScreen({super.key, this.navController, this.onNavigate});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen>
    with SingleTickerProviderStateMixin {

  final _n = TextEditingController();
  final _p = TextEditingController();
  final _i = TextEditingController();

  String _cat = "Indoor Plants";
  bool _best = false;

  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> orders = [];

  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    final p = await DatabaseHelper.getProducts();
    final o = await DatabaseHelper.getOrders();

    if (!mounted) return;

    setState(() {
      products = p;
      orders = o;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F4),
      appBar: AppBar(
          automaticallyImplyLeading: false,
        title: const Text(
          'Admin Panel - Plant Shop',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Color(0xFF1E3525)),
        ),
        backgroundColor: const Color(0xFFF4F7F4),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (r) => false),
            icon: const Icon(Icons.home),
          )
        ],
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tab,
            labelColor: const Color(0xFF4E7D5A),
            tabs: const [
              Tab(text: 'Add'),
              Tab(text: 'Products'),
              Tab(text: 'Orders')
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _buildAdd(),
                _buildList(true),
                _buildList(false)
              ],
            ),
          )
        ],
      ),
    );
  }

  // اضافة منتج
  Widget _buildAdd() => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: _n, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _p, decoration: const InputDecoration(labelText: 'Price')),
          TextField(controller: _i, decoration: const InputDecoration(labelText: 'Image Path')),

          DropdownButtonFormField(
            value: _cat,
            items: ["Indoor Plants", "Climbing Plants", "Succulents", "Flowers"]
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _cat = v!),
          ),

          SwitchListTile(
            title: const Text("Best Seller"),
            value: _best,
            onChanged: (v) => setState(() => _best = v),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E7D5A)),
            onPressed: () async {
              await DatabaseHelper.insertProduct({
                'name': _n.text,
                'price': int.tryParse(_p.text) ?? 0,
                'image': _i.text,
                'category': _cat,
                'isBestSeller': _best ? 1 : 0
              });

              await loadData();

              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('Saved!')));
            },
            child: const Text('Save Product',
                style: TextStyle(color: Colors.white)),
          )
        ],
      );

  // list المنتجات والطلبات
  Widget _buildList(bool isP) {
    final list = isP ? products : orders;

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (c, i) {
        final item = list[i];

        return AdminListItem(
          title: isP
              ? item['name']
              : '${item['customer']} - Order #${item['id']}',

          subtitle: isP
              ? '${item['category']} - ${item['price']} LYD'
              : 'Phone: ${item['phone']} • Total: ${item['total']} LYD',

          trailing: isP
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditProductDialog(item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await DatabaseHelper.deleteProduct(item['id']);
                        await loadData();
                      },
                    ),
                  ],
                )
              : const Icon(Icons.info),

          onTap: isP
              ? null
              : () => showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                      title: Text('Order #${item['id']} Details'),
                      content: Text(
                          'Customer: ${item['customer']}\n'
                          'Phone: ${item['phone']}\n'
                          'Address: ${item['address']}\n'
                          'Items: ${item['items']}\n'
                          'Total: ${item['total']} LYD'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text('Close'),
                        )
                      ],
                    ),
                  ),
        );
      },
    );
  }

  // تعديل منتج
  void _showEditProductDialog(Map<String, dynamic> item) {
    final name = TextEditingController(text: item['name'] ?? '');
    final price = TextEditingController(text: item['price'].toString());
    final image = TextEditingController(text: item['image'] ?? '');

    String category = item['category'] ?? "Indoor Plants";

    bool best = item['isBestSeller'] == 1 ||
        item['isBestSeller'] == '1' ||
        item['isBestSeller'] == true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Edit Product'),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: name),
                    TextField(
                      controller: price,
                      keyboardType: TextInputType.number,
                    ),
                    TextField(controller: image),

                    DropdownButtonFormField(
                      value: category,
                      items: ["Indoor Plants", "Climbing Plants", "Succulents", "Flowers"]
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) {
                        setStateDialog(() {
                          category = v.toString();
                        });
                      },
                    ),

                    SwitchListTile(
                      title: const Text("Best Seller"),
                      value: best,
                      onChanged: (v) {
                        setStateDialog(() {
                          best = v;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () async {
                    final db = await DatabaseHelper.db;
                    
                    await db.update(
                      'products',
                      {
                        'name': name.text.trim(),
                        'price': int.tryParse(price.text.trim()) ?? 0,
                        'image': image.text.trim(),
                        'category': category,
                        'isBestSeller': best ? 1 : 0,
                      },
                      where: 'id = ?',
                      whereArgs: [item['id']],
                    );

                    await loadData();
                    if (!mounted) return;
                    Navigator.pop(dialogContext);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Product updated!')),
                    );},
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}