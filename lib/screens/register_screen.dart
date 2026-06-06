import 'package:flutter/material.dart';
import 'dart:ui'; // مكتبة التأثيرات ( BackdropFilter)
import '../database/database_helper6.dart';
import '../models/models.dart';
import '../widgets/custom_text_field.dart';

// شاشة إنشاء حساب جديد (تسجيل مستخدم جديد)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // متحكمات حقول الإدخال لكل حقل من حقول المستخدم
  final _controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'phone': TextEditingController(),
    'address': TextEditingController(),
    'password': TextEditingController(),
  };

  String selectedRole = 'user'; // نوع الحساب المختار 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container( 
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('images/4.jpg'), fit: BoxFit.cover), 
        ),
        child: BackdropFilter( 
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // تأثير ضبابي  
          child: Container(
            color: Colors.black.withOpacity(0.3), 
            child: SafeArea( 
              child: SingleChildScrollView( // قابل للتمرير 
                padding: const EdgeInsets.symmetric(horizontal: 20), 
                child: Column(
                  children: [
                    Align( // زر الرجوع في أعلى اليسار
                      alignment: Alignment.topLeft, 
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white), 
                        onPressed: () => Navigator.pop(context) // العودة إلى الشاشة السابقة
                      )
                    ),
                    Image.asset('images/logo1.png', width: 180, height: 150), // شعار التطبيق
                    _buildRegisterForm(), // نموذج التسجيل الحقول والأزرار
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95), 
        borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          const Text('Create Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // عنوان النموذج
          const SizedBox(height: 10),
          CustomTextField(controller: _controllers['name']!, label: 'Full Name', icon: Icons.person),
          CustomTextField(controller: _controllers['email']!, label: 'Email', icon: Icons.email),
          CustomTextField(controller: _controllers['password']!, label: 'Password', icon: Icons.lock, obscure: true),
          CustomTextField(controller: _controllers['phone']!, label: 'Phone', icon: Icons.phone, keyboardType: TextInputType.phone),
          CustomTextField(controller: _controllers['address']!, label: 'Address', icon: Icons.location_on),
          // قائمة لاختيار نوع الحساب 
          SizedBox(
            height: 50,
            child: DropdownButtonFormField<String>(
              value: selectedRole, // القيمة المحددة حاليا 
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), 
                prefixIcon: Icon(Icons.admin_panel_settings),
                labelText: 'Account Type', 
                border: OutlineInputBorder(),
              ),
              items: const [ // خيارات القائمة المنسدلة
                DropdownMenuItem(value: 'user', child: Text('Normal User')), 
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (val) => setState(() => selectedRole = val!), // عند تغيير القيمة قم بتحديث المتغير
            ),
          ),
          
          const SizedBox(height: 10),
          // زر إنشاء الحساب
          SizedBox(
            width: double.infinity, 
            height: 45,
            child: ElevatedButton(
              onPressed: _registerUser, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E7D5A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)) 
              ),
              child: const Text('Create Account', style: TextStyle(color: Colors.white, fontSize: 16)), 
            ),
          ),
        ],
      ),
    );
  }
  // دالة تسجيل مستخدم جديد 
  void _registerUser() async {
    final newUser = UserModel(
      name: _controllers['name']!.text,
      email: _controllers['email']!.text,
      password: _controllers['password']!.text,
      phone: _controllers['phone']!.text,
      address: _controllers['address']!.text,
      role: selectedRole, 
    );

    await DatabaseHelper.insertUser(newUser.toMap());// إدراج المستخدم في قاعدة البيانات (تحويل الكائن إلى Map باستخدام toMap)
    if (mounted) { // إذا كانت الشاشة لا زالت موجودة
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created!')));
      Navigator.pushReplacementNamed(context, '/login');// الانتقال إلى شاشة تسجيل الدخول
    }
  }
}