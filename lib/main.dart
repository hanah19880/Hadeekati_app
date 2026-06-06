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
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static bool isGuest = true;       
  static bool isAdmin = false;      
  static String? userEmail;         

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Hadeekati',
      initialRoute: '/',              
      routes: {
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
