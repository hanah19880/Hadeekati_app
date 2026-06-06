
class UserModel {
  final int? id; 
  final String name, email, password, phone, address, role; 


  UserModel({
    this.id, 
    required this.name, 
    required this.email, 
    required this.password, 
    required this.phone, 
    required this.address, 
    this.role = 'user' 
  });

  // Factory Constructor: يحول Map قادم من قاعدة البيانات إلى كائن UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'], 
    name: map['name'] ?? '', 
    email: map['email'] ?? '', 
    password: map['password'] ?? '', 
    phone: map['phone'] ?? '', 
    address: map['address'] ?? '', 
    role: map['role'] ?? 'user' 
  );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, 
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }
  bool get isAdmin => role == 'admin';
}
class ProductModel {
  final int? id; 
  final String name, image, category; 
  final int price; 
  final bool isBestSeller; 

  ProductModel({
    this.id, 
    required this.name, 
    required this.price, 
    required this.image, 
    required this.category, 
    this.isBestSeller = false 
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['id'], 
    name: map['name'] ?? '', 
    price: int.tryParse(map['price'].toString()) ?? 0, 
    image: map['image'] ?? '', 
    category: map['category'] ?? '', 
    isBestSeller: map['isBestSeller'] == 1 || map['isBestSeller'] == true 
  );

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'image': image,
      'category': category,
      'isBestSeller': isBestSeller ? 1 : 0, 
    };
  }
}
// CartItem: 
class CartItem {
  String name;
  int price, quantity; 
  CartItem({required this.name, required this.price, required this.quantity});
    int get itemTotal => price * quantity;
}

class Cart {
  static List<CartItem> items = []; 
  static void addItem(String name, int price, int quantity) { 
    int index = items.indexWhere((e) => e.name == name); 
    if (index != -1) { 
      items[index].quantity += quantity; 
    } else { 
      items.add(CartItem(name: name, price: price, quantity: quantity)); 
    }}

  static void removeItem(int index) => items.removeAt(index); 
  static void clear() => items.clear(); 
  static int getTotal() => items.fold(0, (sum, item) => sum + item.itemTotal);  
}
