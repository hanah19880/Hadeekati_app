import 'package:flutter/material.dart';
import '../models/models.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product; 
  final bool isAdmin; 
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

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), 
                image: DecorationImage(
                  image: AssetImage(product.image), 
                  fit: BoxFit.cover, 
                ),
              ),
            ),
          ),          

          Padding(
            padding: const EdgeInsets.all(12.0), 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text( 
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
                    
                    if (!isAdmin)   
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
