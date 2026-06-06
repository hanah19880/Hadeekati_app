import 'package:flutter/material.dart';

class AdminListItem extends StatelessWidget {
  final String title; 
  final String subtitle; 
  final Widget? trailing; // عنصر جانبي مثل: زر حذف أو أيقونة معلومات
  final VoidCallback? onTap; 

  // كونستركتور يتطلب title و subtitle، والباقي اختياري
  const AdminListItem({
    super.key, 
    required this.title, 
    required this.subtitle, 
    this.trailing, 
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Card( 
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // هوامش خارجية (يمين/يسار 10، أعلى/أسفل 5)
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // زوايا دائرية (نصف قطر 12)
      child: ListTile( 
        onTap: onTap, 
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)), 
        subtitle: Text(subtitle), 
        trailing: trailing,
      ),
    );
  }
}