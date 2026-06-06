import 'package:flutter/material.dart';

//  كلاس لتغليف بيانات القسم
class CategoryModel {
  final String title; 
  final String image; 

  CategoryModel({required this.title, required this.image});
}

//  كارت عرض القسم كمكون مستقل
class CategoryCard extends StatelessWidget {
  final CategoryModel category; // بيانات التصنيف المراد عرضها
  final VoidCallback onTap; // دالة يتم استدعاؤها عند الضغط على الكارت

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // يكتشف النقرات (يجعل الكارت قابلاً للضغط)
      onTap: onTap, 
      child: Container(
        width: 90, 
        margin: const EdgeInsets.only(right: 14), 
        child: Column( 
          children: [
            Container(
              width: 65, 
              height: 65, 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18), 
                image: DecorationImage( 
                  image: AssetImage(category.image), 
                  fit: BoxFit.cover, 
                ),
                boxShadow: [ 
                  BoxShadow(
                    color: Colors.grey.shade200, 
                    blurRadius: 8, 
                    offset: const Offset(0, 3), 
                  )
                ],
              ),
            ),
            const SizedBox(height: 8), 
            Text( 
              category.title,
              maxLines: 1, 
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600, 
                color: Color(0xFF2C4A35),
              ),
            ),
          ],
        ),
      ),
    );
  }
}