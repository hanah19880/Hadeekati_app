import 'dart:async'; // مكتبة المؤقتات (Timer)
import 'package:flutter/material.dart';

// شاشة البداية تظهر عند تشغيل التطبيق لمدة 7 ثواني
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin { 
  late AnimationController _animationController; 
  late Animation<double> _fadeAnimation; // حركة التلاشي

  @override
  void initState() {
    super.initState();
    
    
    _animationController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1500),);  
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);    //  حركة التلاشي تبدأ تدريجيا 
    _animationController.forward(); // تظهر العناصر تدريجيا
   
    Timer(const Duration(seconds: 14), () {  
      Navigator.pushReplacementNamed(context, '/home'); 
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Stack( 
        children: [
          Positioned(
            top: -100, 
            right: -100, 
            child: CircleAvatar(
              radius: 150, 
              backgroundColor: const Color(0xFF4E7D5A).withOpacity(0.05), 
            ),
          ),
          
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation, // تطبيق  التلاشي على المحتوى كامل
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
             
                  Container(     //  دائرية مع ظل
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle, 
                      boxShadow: [ 
                        BoxShadow(
                          color: const Color(0xFF4E7D5A).withOpacity(0.1), 
                          blurRadius: 30, 
                          offset: const Offset(0, 10), 
                        ),
                      ],
                    ),
                    child: ClipRRect( 
                      borderRadius: BorderRadius.circular(160),
                      child: Image.asset(
                        'images/logo.png', 
                        width: 260, 
                        height: 260, 
                        fit: BoxFit.contain, 
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Hadeekati Store",
                    style: TextStyle(
                      color: Color(0xFF2C4A35), 
                      fontSize: 28, 
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5, 
                    ),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    "Welcome to your green space",
                    style: TextStyle(
                      color: const Color(0xFF4E7D5A).withOpacity(0.6), 
                      fontSize: 15,
                      fontWeight: FontWeight.w400, 
                    ),
                  ),
                  const SizedBox(height: 60), 
                  const SizedBox(
                    width: 24,  
                    height: 24, 
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5, 
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4E7D5A)), 
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
