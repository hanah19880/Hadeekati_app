// lib/widgets/cart_item_card.dart
import 'package:flutter/material.dart';
import '../models/models.dart';

// بطاقة تعرض عنصراً واحداً في سلة المشتريات (اسم المنتج، السعر، الكمية، أزرار التحكم)
class CartItemCard extends StatelessWidget {
  final CartItem item; // عنصر السلة (يحتوي على الاسم، السعر، الكمية)
  final VoidCallback onAdd; // دالة يتم استدعاؤها عند الضغط على زر + (زيادة الكمية)
  final VoidCallback onRemove; // دالة يتم استدعاؤها عند الضغط على زر - (نقص الكمية أو حذف العنصر)

  const CartItemCard({super.key, required this.item, required this.onAdd, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), 
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade100, blurRadius: 10, offset: const Offset(0, 4))], 
      ),
      child: Row( 
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE8F0E9), 
            radius: 24, 
            child: Text('🌿', style: TextStyle(fontSize: 20)) 
          ),
          const SizedBox(width: 14), 
          
          Expanded( // عمود يحتوي على اسم المنتج وسعره (يأخذ المساحة المتاحة)
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E3525))), 
                Text('${item.price} LYD', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)), 
              ],
            ),
          ),

          Row(
            children: [
              IconButton(onPressed: onRemove, icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF4E7D5A))),
              Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), 
              IconButton(onPressed: onAdd, icon: const Icon(Icons.add_circle_outline, color: Color(0xFF4E7D5A))), 
            ],
          )
        ],
      ),
    );
  }
}