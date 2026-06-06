import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _db;
  static String? currentUserRole;
  static Map<String, dynamic>? currentUser;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'hadeekati.db');

    return await openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT UNIQUE,
            password TEXT,
            phone TEXT,
            address TEXT,
            role TEXT DEFAULT 'user'
          )
        ''');

        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price INTEGER,
            image TEXT,
            category TEXT,
            isBestSeller INTEGER DEFAULT 0
          )
        ''');

        await db.execute('''
          CREATE TABLE orders(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customer TEXT,
            phone TEXT,
            address TEXT,
            items TEXT,
            time TEXT,
            status TEXT,
            total INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          try {
            await db.execute("ALTER TABLE products ADD COLUMN isBestSeller INTEGER DEFAULT 0");
          } catch (_) {}
        }
      },
    );
  }

  static Future<void> insertUser(Map<String, dynamic> user) async {
    final dbClient = await db;
    await dbClient.insert('users', user);
  }

  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    
    if (result.isNotEmpty) {
      currentUserRole = result.first['role'] as String?;
      currentUser = result.first;
      return result.first;
    }
    return null;
  }

  static Future<Map<String, dynamic>?> getUser() async {
    if (currentUser != null) return currentUser;
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient.query('users', limit: 1);
    if (result.isNotEmpty) {
      currentUser = result.first;
      currentUserRole = result.first['role'] as String?;
      return result.first;
    }
    return null;
  }

  static Future<void> updateUser(int id, Map<String, dynamic> data) async {
    final dbClient = await db;
    await dbClient.update('users', data, where: 'id = ?', whereArgs: [id]);
    if (currentUser != null && currentUser!['id'] == id) {
      currentUser = data;
    }
  }

  static Future<void> logout() async {
    currentUserRole = null;
    currentUser = null;
  }

  static bool isLoggedIn() {
    return currentUserRole != null;
  }

  static bool isAdmin() {
    return currentUserRole == 'admin';
  }

  static Future<void> insertProduct(Map<String, dynamic> product) async {
    final dbClient = await db;
    await dbClient.insert('products', product);
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final dbClient = await db;
    return await dbClient.query('products');
  }

  static Future<List<Map<String, dynamic>>> getBestSellerProducts() async {
    final dbClient = await db;
    return await dbClient.query(
      'products',
      where: 'isBestSeller = ?',
      whereArgs: [1],
    );
  }

  static Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    final dbClient = await db;
    return await dbClient.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  static Future<void> updateBestSellerStatus(int id, bool isBestSeller) async {
    final dbClient = await db;
    await dbClient.update(
      'products',
      {'isBestSeller': isBestSeller ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> deleteProduct(int id) async {
    final dbClient = await db;
    await dbClient.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> insertOrder(Map<String, dynamic> order) async {
    final dbClient = await db;
    await dbClient.insert('orders', order);
  }

  static Future<List<Map<String, dynamic>>> getOrders() async {
    final dbClient = await db;
    return await dbClient.query('orders', orderBy: 'id DESC');
  }

  static Future<void> deleteOrder(int id) async {
    final dbClient = await db;
    await dbClient.delete('orders', where: 'id = ?', whereArgs: [id]);
  }

  //    لتحديث حالة الطلب
  static Future<void> updateOrderStatus(int id, String status) async {
    final dbClient = await db;
    await dbClient.update(
      'orders',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    final dbClient = await db;
    return await dbClient.query(
      'orders',
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'id DESC',
    );
  }

  static Future<void> createAdminIfNotExists() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> result = await dbClient.query('users', where: 'role = ?', whereArgs: ['admin']);
    if (result.isEmpty) {
      await dbClient.insert('users', {
        'name': 'Admin',
        'email': 'admin@admin.com',
        'password': '123456',
        'phone': '123456789',
        'address': 'Admin Office',
        'role': 'admin',
      });
    }
  }
}