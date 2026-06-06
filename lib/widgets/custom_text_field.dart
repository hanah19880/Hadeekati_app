import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller; 
  final String label; 
  final IconData icon; 
  final bool obscure; 
  final TextInputType keyboardType; 
  final Widget? suffixIcon; 

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false, 
    this.keyboardType = TextInputType.text, 
    this.suffixIcon, 
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12), 
      child: TextField(
        controller: controller, 
        obscureText: obscure, 
        keyboardType: keyboardType, 
        style: const TextStyle(fontSize: 15, color: Color(0xFF1E3525)), 
        decoration: InputDecoration(
          isDense: true, 
          floatingLabelBehavior: FloatingLabelBehavior.never, 
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14), 
          prefixIcon: Icon(icon, color: const Color(0xFF4E7D5A), size: 20),
          suffixIcon: suffixIcon, 
          filled: true, 
          fillColor: Colors.white,       
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), 

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14), 
            borderSide: const BorderSide(color: Color(0xFF4E7D5A), width: 1.5), 
          ),
        ),
      ),
    );
  }
}
