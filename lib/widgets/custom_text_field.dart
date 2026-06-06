import 'package:flutter/material.dart';

// حقل إدخال نصي مخصص (Custom Text Field) - يُستخدم في جميع شاشات التطبيق للحفاظ على تناسق التصميم
class CustomTextField extends StatelessWidget {
  final TextEditingController controller; // متحكم النص (لقراءة وكتابة القيمة)
  final String label; // النص الذي يظهر داخل الحقل كتسمية (مثال: "Email", "Password")
  final IconData icon; // الأيقونة التي تظهر على يسار الحقل
  final bool obscure; // هل النص مخفي؟ (true لكلمة المرور، false للبريد الإلكتروني والاسم)
  final TextInputType keyboardType; // نوع لوحة المفاتيح (نص، أرقام، بريد إلكتروني...)
  final Widget? suffixIcon; // عنصر إضافي على يمين الحقل (مثل زر إظهار/إخفاء كلمة المرور)

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false, // افتراضياً النص غير مخفي
    this.keyboardType = TextInputType.text, // افتراضياً لوحة مفاتيح نصية عادية
    this.suffixIcon, // افتراضياً لا يوجد عنصر على اليمين
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), 
      child: TextField(
        controller: controller, // ربط المتحكم بالحقل
        obscureText: obscure, // إخفاء النص إذا كانت obscure = true (لكلمة المرور)
        keyboardType: keyboardType, 
        style: const TextStyle(fontSize: 15, color: Color(0xFF1E3525)), 
        decoration: InputDecoration(
          isDense: true, // يجعل الحقل أقل ارتفاعاً (يقلل المسافات الداخلية)
          floatingLabelBehavior: FloatingLabelBehavior.never, // التسمية لا تطفو فوق الحقل (تبقى ثابتة)
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14), 
          prefixIcon: Icon(icon, color: const Color(0xFF4E7D5A), size: 20),
          suffixIcon: suffixIcon, // أيقونة أو عنصر على اليمين مثل زر العين لكلمة المرور
          filled: true, // تفعيل الخلفية المعبأة (بدون شفافية)
          fillColor: Colors.white,       
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), 
          // حدود الحقل في حالة عدم التركيز (غير نشط)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          
          // حدود الحقل في حالة التركيز
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14), 
            borderSide: const BorderSide(color: Color(0xFF4E7D5A), width: 1.5), 
          ),
        ),
      ),
    );
  }
}