import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/category_screen.dart';
import 'screens/admin_panel_screen.dart';

void main() {
  runApp(MyApp()); // تشغيل التطبيق
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ========== المتغيرات العامة لحالة المستخدم ==========
  // static تعني أن هذه المتغيرات تابعة للكلاس نفسه، يمكن الوصول إليها من أي مكان دون إنشاء كائن
  static bool isGuest = true;       // وضع الضيف: يتحكم بعرض واجهة مختلفة للضيف
  static bool isAdmin = false;      // تحديد إذا كان المستخدم أدمن للوصول للوحة التحكم
  static String? userEmail;         // تخزين بريد المستخدم للاستخدامات المختلفة

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Hadeekati',
      initialRoute: '/',              
      routes: {
        // تعريف مسارات الشاشات (Routing)
        '/': (context) => SplashScreen(),   
        '/home': (context) => HomeScreen(),  
        '/login': (context) => LoginScreen(), 
        '/register': (context) => RegisterScreen(), 
        '/cart': (context) => CartScreen(),  
        '/profile': (context) => ProfileScreen(), 
        '/category': (context) => CategoryScreen(), 
        '/admin': (context) => AdminPanelScreen(), 
      },
    );
  }
}