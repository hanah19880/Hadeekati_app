
class UserModel {
  final int? id; // معرف المستخدم (اختياري لأن المستخدم الجديد لا يملك id بعد)
  final String name, email, password, phone, address, role; 

  // كونستركتور: يتطلب جميع البيانات ماعدا id و role (للـ role قيمة افتراضية 'user')
  UserModel({
    this.id, 
    required this.name, 
    required this.email, 
    required this.password, 
    required this.phone, 
    required this.address, 
    this.role = 'user' // دور المستخدم: 'user' للمستخدم العادي، 'admin' للأدمن
  });

  // Factory Constructor: يحول Map قادم من قاعدة البيانات إلى كائن UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'], 
    name: map['name'] ?? '', // إذا كانت القيمة null استخدم سلسلة فارغة
    email: map['email'] ?? '', 
    password: map['password'] ?? '', 
    phone: map['phone'] ?? '', 
    address: map['address'] ?? '', 
    role: map['role'] ?? 'user' 
  );

  // toMap: يحول كائن UserModel إلى Map لإدراجه أو تحديثه في قاعدة البيانات
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, // إذا كان id موجوداً أضفه (يُستخدم في التحديث)
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
      'role': role,
    };
  }
  bool get isAdmin => role == 'admin';// Getter: يعيد true إذا كان المستخدم أدمن، false إذا كان مستخدم عادي
}
// كلاس المنتج (ProductModel) - يمثل بيانات المنتج في المتجر
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
    this.isBestSeller = false // افتراضياً ليس من الأكثر مبيعاً
  });

  // Factory Constructor: يحول Map من قاعدة البيانات إلى كائن ProductModel
  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map['id'], 
    name: map['name'] ?? '', 
    price: int.tryParse(map['price'].toString()) ?? 0, // تحويل آمن إلى int (إذا فشل التحويل يصبح 0)
    image: map['image'] ?? '', 
    category: map['category'] ?? '', 
    isBestSeller: map['isBestSeller'] == 1 || map['isBestSeller'] == true // يقبل 1 أو true
  );

  // toMap: يحول كائن ProductModel إلى Map لقاعدة البيانات
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
// CartItem: يمثل عنصراً واحداً في سلة المشتريات
class CartItem {
  String name;
  int price, quantity; 
  CartItem({required this.name, required this.price, required this.quantity});
    int get itemTotal => price * quantity;
}

// Cart: كلاس ثابت (static) يدير السلة بأكملها (لا يحتاج إلى إنشاء كائن)
class Cart {
  static List<CartItem> items = []; // قائمة عناصر السلة (تخزن في الذاكرة طالما التطبيق مفتوح)
  static void addItem(String name, int price, int quantity) { // إضافة عنصر إلى السلة أو زيادة كميته إذا كان موجوداً بالفعل
    int index = items.indexWhere((e) => e.name == name); // البحث عن المنتج في السلة
    if (index != -1) { // إذا كان المنتج موجوداً
      items[index].quantity += quantity; // زيادة الكمية
    } else { // إذا لم يكن موجوداً
      items.add(CartItem(name: name, price: price, quantity: quantity)); // إضافة عنصر جديد
    }}

  static void removeItem(int index) => items.removeAt(index); // حذف عنصر حسب الفهرس
  static void clear() => items.clear(); // تفريغ السلة بالكامل
  static int getTotal() => items.fold(0, (sum, item) => sum + item.itemTotal);  // حساب الإجمالي الكلي للسلة باستخدام fold (طريقة برمجية وظيفية)
}