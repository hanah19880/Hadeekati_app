import 'dart:async'; // مكتبة المؤقتات (Timer)
import 'package:flutter/material.dart';

// شاشة البداية تظهر عند تشغيل التطبيق لمدة 7 ثواني
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin { // SingleTickerProviderStateMixin مطلوب لـ AnimationController
  late AnimationController _animationController; //متحكم الحركة يبدأ ويوقف الأنيميشن
  late Animation<double> _fadeAnimation; // حركة التلاشي  من 0.0 إلى 1.0

  @override
  void initState() {
    super.initState();
    
    // تهيئة متحكم الحركة 
    _animationController = AnimationController(
      vsync: this, // ربط المتحكم بالشاشة لتحسين الأداء
      duration: const Duration(milliseconds: 1500),);  
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);    //  حركة التلاشي تبدأ تدريجيا 
    _animationController.forward(); // تظهر العناصر تدريجيا
   
    Timer(const Duration(seconds: 14), () {  // مؤقت لمدة 7 ثواني ثم الانتقال إلى الصفحة الرئيسية
      Navigator.pushReplacementNamed(context, '/home'); 
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // التخلص من متحكم الحركة لتجنب تسرب الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Stack( 
        children: [
          Positioned(// دائرة زخرفية في أعلى اليمين (خلفية جمالية تعبر عن الطبيعة)
            top: -100, 
            right: -100, 
            child: CircleAvatar(
              radius: 150, 
              backgroundColor: const Color(0xFF4E7D5A).withOpacity(0.05), 
            ),
          ),
          
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation, // تطبيق حركة التلاشي على المحتوى بأكمله
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
             
                  Container(     // حاوية الشعار (دائرية مع ظل)
                    decoration: BoxDecoration(
                      color: Colors.white, 
                      shape: BoxShape.circle, // شكل دائري
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
                        fit: BoxFit.contain, // تجعل الصورة داخل الإطار دون قصها
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
                  const SizedBox(// مؤشر تحميل دائري صغير (للدلالة على أن التطبيق يعمل)
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