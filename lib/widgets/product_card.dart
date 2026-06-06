import 'package:flutter/material.dart';
import '../models/models.dart'; // استيراد كلاس ProductModel من ملف النماذج

// بطاقة عرض المنتج (تظهر في شبكة المنتجات في HomeScreen و CategoryScreen)
class ProductCard extends StatelessWidget {
  final ProductModel product; // بيانات المنتج الاسم، السعر، الصورة، التصنيف، حالة BestSeller
  final bool isAdmin; //  يحدد إذا كان يظهر زر إضافة إلى السلة أم لا
  final VoidCallback onAddToCart; 

  const ProductCard({
    super.key,
    required this.product,
    required this.isAdmin,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20), 
        boxShadow: [ 
          BoxShadow(
            color: Colors.grey.shade100, 
            blurRadius: 10,
            offset: const Offset(0, 4), 
          )
        ],
      ),
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // قسم الصورة 
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), 
                image: DecorationImage(
                  image: AssetImage(product.image), // تحميل الصورة من المسار المحدد في ProductModel
                  fit: BoxFit.cover, 
                ),
              ),
            ),
          ),          
          // قسم النص (أسفل الصورة)
          Padding(
            padding: const EdgeInsets.all(12.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text( // اسم المنتج
                  product.name,
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis, 
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 14,
                    color: Color(0xFF1E3525), 
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( 
                      "${product.price} LYD",
                      style: const TextStyle(
                        color: Color(0xFF4E7D5A),
                        fontWeight: FontWeight.bold, 
                        fontSize: 13,
                      ),
                    ),
                    
                    if (!isAdmin)   // زر إضافة إلى السلة (يظهر فقط إذا لم يكن المستخدم أدمن)
                      IconButton(
                        constraints: const BoxConstraints(), 
                        padding: EdgeInsets.zero, 
                        icon: const Icon(
                          Icons.add_shopping_cart_rounded, 
                          color: Color(0xFF4E7D5A), 
                          size: 20, 
                        ),
                        onPressed: onAddToCart, 
                      ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}